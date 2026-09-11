# Dev Environment Builder 

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Ubuntu](https://img.shields.io/badge/Ubuntu-Compatible-orange.svg)](https://ubuntu.com/)
[![LXD](https://img.shields.io/badge/LXD-Powered-blue.svg)](https://linuxcontainers.org/lxd/)

> Turn any ubuntu/fedora image into a lxd/docker dev environment.

The script **permanently** converts your Linux host as a Docker/LXD server with Ansible, Lxde, Dev Tools, MeteorJS, Rustup, along with the linux kernel dummy module trick for studying kubernetes [(Read the kernel docs - for k8s)](https://www.kernel.org/doc/html/latest/).


## Quick Start

**WARNING: (THIS SCRIPT IS IRREVERSABLE!), 🌌.** 

* Ensure your host is backed up. Once you launch this script, you can **never undo it.**
* Ensure it is a *recent* Ubuntu/Fedora release.
* Launch the bash and follow the prompts, including neovim with a :quit to let it initiate.
```bash
   bash ./bldub.sh
```
