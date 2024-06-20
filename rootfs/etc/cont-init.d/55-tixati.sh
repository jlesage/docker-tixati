#!/bin/sh

set -e # Exit immediately if a command exits with a non-zero status.
set -u # Treat unset variables as an error.

# Make sure the configuration directory exists.
mkdir -p "$XDG_CONFIG_HOME"/tixati

# Install default configuration.
[ -f "$XDG_CONFIG_HOME"/tixati/settings2.dat ] || cp /defaults/settings2.dat "$XDG_CONFIG_HOME"/tixati/settings2.dat
[ -f "$XDG_CONFIG_HOME"/tixati/colors2.dat ] || cp /defaults/colors2.dat "$XDG_CONFIG_HOME"/tixati/colors2.dat

# Take ownership of the output directory.
take-ownership --not-recursive /output

# vim:ft=sh:ts=4:sw=4:et:sts=4
