# Docker container for Tixati
[![Release](https://img.shields.io/github/release/jlesage/docker-tixati.svg?logo=github&style=for-the-badge)](https://github.com/jlesage/docker-tixati/releases/latest)
[![Docker Image Size](https://img.shields.io/docker/image-size/jlesage/tixati/latest?logo=docker&style=for-the-badge)](https://hub.docker.com/r/jlesage/tixati/tags)
[![Docker Pulls](https://img.shields.io/docker/pulls/jlesage/tixati?label=Pulls&logo=docker&style=for-the-badge)](https://hub.docker.com/r/jlesage/tixati)
[![Docker Stars](https://img.shields.io/docker/stars/jlesage/tixati?label=Stars&logo=docker&style=for-the-badge)](https://hub.docker.com/r/jlesage/tixati)
[![Build Status](https://img.shields.io/github/actions/workflow/status/jlesage/docker-tixati/build-image.yml?logo=github&branch=master&style=for-the-badge)](https://github.com/jlesage/docker-tixati/actions/workflows/build-image.yml)
[![Source](https://img.shields.io/badge/Source-GitHub-blue?logo=github&style=for-the-badge)](https://github.com/jlesage/docker-tixati)
[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg?style=for-the-badge)](https://paypal.me/JocelynLeSage)

This is a Docker container for [Tixati](https://www.tixati.com).

The graphical user interface (GUI) of the application can be accessed through a
modern web browser, requiring no installation or configuration on the client

> This Docker container is entirely unofficial and not made by the creators of
> Tixati.

---

[![Tixati logo](https://images.weserv.nl/?url=raw.githubusercontent.com/jlesage/docker-templates/master/jlesage/images/tixati-icon.png&w=110)](https://www.tixati.com)[![Tixati](https://images.placeholders.dev/?width=192&height=110&fontFamily=monospace&fontWeight=400&fontSize=52&text=Tixati&bgColor=rgba(0,0,0,0.0)&textColor=rgba(121,121,121,1))](https://www.tixati.com)

Tixati is a peer-to-peer file sharing program that uses the popular BitTorrent
protocol.

---

## Quick Start

**NOTE**:
    The Docker command provided in this quick start is an example, and parameters
    should be adjusted to suit your needs.

Launch the Tixati docker container with the following command:
```shell
docker run -d \
    --name=tixati \
    -p 5800:5800 \
    -p 17844:17844/tcp \
    -p 17844:17844/udp \
    -v /docker/appdata/tixati:/config:rw \
    -v /home/user/Downloads:/output:rw \
    jlesage/tixati
```

Where:

  - `/docker/appdata/tixati`: Stores the application's configuration, state, logs, and any files requiring persistency.
  - `/home/user/Downloads`: This is where downloaded files are stored.

Access the Tixati GUI by browsing to `http://your-host-ip:5800`.

## Documentation

Full documentation is available at https://github.com/jlesage/docker-tixati.

## Support or Contact

Having troubles with the container or have questions? Please
[create a new issue](https://github.com/jlesage/docker-tixati/issues).

For other Dockerized applications, visit https://jlesage.github.io/docker-apps.
