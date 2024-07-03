#!/bin/bash

set -e # Exit immediately if a command exits with a non-zero status.
set -u # Treat unset variables as an error.

export DEBIAN_FRONTEND=noninteractive

SCRIPT_DIR="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

TIXATI_ROOTFS=/tmp/tixati-rootfs
TIXATI_INSTALL_DIR=/opt/tixati

function log {
    echo ">>> $*"
}

TIXATI_URL="$1"

if [ -z "$TIXATI_URL" ]; then
    log "ERROR: Tixati URL missing."
    exit 1
fi

log "Updating APT cache..."
apt-get update

log "Installing build prerequisites..."
apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    locales \
    patchelf \
    rsync \
    libgtk-3-0 \
    libdbus-glib-1-2 \
    librsvg2-common \
    adwaita-icon-theme-full \
    xdo \

# Generate locale.
locale-gen en_US.UTF-8

# Create Tixati install directory.
mkdir -p "$TIXATI_INSTALL_DIR"/bin
mkdir -p "$TIXATI_INSTALL_DIR"/lib

log "Downloading Tixati..."
curl -# -L -f ${TIXATI_URL} | tar xz --wildcards --no-anchored --strip 1 -C "$TIXATI_INSTALL_DIR"/bin "*/tixati"

# Copy xdo used to terminate Tixati.
cp -v /usr/bin/xdo "$TIXATI_INSTALL_DIR"/bin/

# Define extra libraries that are needed.  These libraries are loaded
# dynamically (dlopen) and are not catched by tracking dependencies.
EXTRA_LIBS="
    /usr/lib/x86_64-linux-gnu/gdk-pixbuf-2.0/2.10.0/loaders/libpixbufloader-svg.so
"

log "Copying extra libraries..."
for LIB in $EXTRA_LIBS
do
    cp -av "$LIB"* "$TIXATI_INSTALL_DIR"/lib/
done

log "Extracting shared library dependencies..."
find "$TIXATI_INSTALL_DIR" -type f -executable -or -name 'lib*.so*' | while read BIN
do
    echo "Dependencies for $BIN:"
    RAW_DEPS="$(LD_LIBRARY_PATH="$TIXATI_INSTALL_DIR/lib" ldd "$BIN")"
    echo "================================"
    echo "$RAW_DEPS"
    echo "================================"

    if echo "$RAW_DEPS" | grep -q " not found"; then
        echo "ERROR: Some libraries are missing!"
        exit 1
    fi

    LD_LIBRARY_PATH="$TIXATI_INSTALL_DIR/lib" ldd "$BIN" | (grep " => " || true) | cut -d'>' -f2 | sed 's/^[[:space:]]*//' | cut -d'(' -f1 | while read dep
    do
        dep_real="$(realpath "$dep")"
        dep_basename="$(basename "$dep_real")"

        # Skip already-processed libraries.
        [ ! -f "$TIXATI_INSTALL_DIR/lib/$dep_basename" ] || continue

        echo "  -> Found library: $dep"
        cp "$dep_real" "$TIXATI_INSTALL_DIR/lib/"
        while true; do
            [ -L "$dep" ] || break;
            ln -sf "$dep_basename" "$TIXATI_INSTALL_DIR"/lib/$(basename $dep)
            dep="$(readlink -f "$dep")"
        done

        dep_fname="$(basename "$dep")"
        if [[ "$dep_fname" =~ ^ld-* ]]; then
            echo "$dep_fname" > /tmp/interpreter_fname
            echo "    -> This is the interpreter."
        fi
    done
done

log "Copying interpreter..."
cp -v /lib/x86_64-linux-gnu/ld-linux-x86-64.so.2 "$TIXATI_INSTALL_DIR"/lib/

log "Patching ELF of binaries..."
find "$TIXATI_INSTALL_DIR"/bin -type f -executable -exec echo "  -> Setting interpreter of {}..." ';' -exec patchelf --set-interpreter "$TIXATI_INSTALL_DIR"/lib/ld-linux-x86-64.so.2 {} ';'
find "$TIXATI_INSTALL_DIR"/bin -type f -executable -exec echo "  -> Setting rpath of {}..." ';' -exec patchelf --set-rpath '$ORIGIN/../lib' {} ';'

log "Patching ELF of libraries..."
find "$TIXATI_INSTALL_DIR"/lib -maxdepth 1 -type f -name "lib*" -exec echo "  -> Setting rpath of {}..." ';' -exec patchelf --set-rpath '$ORIGIN' {} ';'

# Fixes the GDK pixbuf loader cache.  The new cache file is used with the
# GDK_PIXBUF_MODULE_FILE environment variable.
cp /usr/lib/x86_64-linux-gnu/gdk-pixbuf-2.0/2.10.0/loaders.cache "$TIXATI_INSTALL_DIR"/
sed "s|/usr/lib/x86_64-linux-gnu/gdk-pixbuf-2.0/2.10.0/loaders/|$TIXATI_INSTALL_DIR/lib/|" -i "$TIXATI_INSTALL_DIR"/loaders.cache

log "Creating rootfs..."
mkdir "$TIXATI_ROOTFS"
ROOTFS_CONTENT="
    $TIXATI_INSTALL_DIR
    /usr/share/glib-2.0/schemas
    /usr/share/icons/Adwaita/index.theme
    /usr/share/icons/Adwaita/scalable
    /usr/share/icons/Adwaita/24x24
    /usr/lib/locale/locale-archive
    /etc/fonts
    /usr/share/mime
    /usr/share/fonts/truetype/dejavu/DejaVuSans.ttf
"
echo "$ROOTFS_CONTENT" | while read i
do
    if [ -n "$i" ]; then
        rsync -Rav "$i" "$TIXATI_ROOTFS"
    fi
done

echo "Content of $TIXATI_ROOTFS:"
find "$TIXATI_ROOTFS"

echo "Tixati built successfully."

# vim:ft=sh:ts=4:sw=4:et:sts=4
