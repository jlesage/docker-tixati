# Docker container for Tixati
[![Release](https://img.shields.io/github/release/jlesage/docker-tixati.svg?logo=github&style=for-the-badge)](https://github.com/jlesage/docker-tixati/releases/latest)
[![Docker Image Size](https://img.shields.io/docker/image-size/jlesage/tixati/latest?logo=docker&style=for-the-badge)](https://hub.docker.com/r/jlesage/tixati/tags)
[![Docker Pulls](https://img.shields.io/docker/pulls/jlesage/tixati?label=Pulls&logo=docker&style=for-the-badge)](https://hub.docker.com/r/jlesage/tixati)
[![Docker Stars](https://img.shields.io/docker/stars/jlesage/tixati?label=Stars&logo=docker&style=for-the-badge)](https://hub.docker.com/r/jlesage/tixati)
[![Build Status](https://img.shields.io/github/actions/workflow/status/jlesage/docker-tixati/build-image.yml?logo=github&branch=master&style=for-the-badge)](https://github.com/jlesage/docker-tixati/actions/workflows/build-image.yml)
[![Source](https://img.shields.io/badge/Source-GitHub-blue?logo=github&style=for-the-badge)](https://github.com/jlesage/docker-tixati)
[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg?style=for-the-badge)](https://paypal.me/JocelynLeSage)

This is a Docker container for [Tixati](https://www.tixati.com).

The GUI of the application is accessed through a modern web browser (no
installation or configuration needed on the client side) or via any VNC client.

---

[![Tixati logo](https://images.weserv.nl/?url=raw.githubusercontent.com/jlesage/docker-templates/master/jlesage/images/tixati-icon.png&w=110)](https://www.tixati.com)[![Tixati](https://images.placeholders.dev/?width=192&height=110&fontFamily=monospace&fontWeight=400&fontSize=52&text=Tixati&bgColor=rgba(0,0,0,0.0)&textColor=rgba(121,121,121,1))](https://www.tixati.com)

Tixati is a peer-to-peer file sharing program that uses the popular BitTorrent
protocol.

---

## Quick Start

**NOTE**: The Docker command provided in this quick start is given as an example
and parameters should be adjusted to your need.

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
  - `/docker/appdata/tixati`: This is where the application stores its configuration, states, log and any files needing persistency.
  - `/home/user/Downloads`: This is where downloaded files are stored.

Browse to `http://your-host-ip:5800` to access the Tixati GUI.

## Documentation

Full documentation is available at https://github.com/jlesage/docker-tixati.

## Support or Contact

Having troubles with the container or have questions?  Please
[create a new issue].

For other great Dockerized applications, see https://jlesage.github.io/docker-apps.

[create a new issue]: https://github.com/jlesage/docker-tixati/issues
