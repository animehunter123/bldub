# Dev Environment Builder (Unsafe)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Ubuntu](https://img.shields.io/badge/Ubuntu-Compatible-orange.svg)](https://ubuntu.com/)
[![LXD](https://img.shields.io/badge/LXD-Powered-blue.svg)](https://linuxcontainers.org/lxd/)

> Unsafely turn the ubuntu server to be capable of running virtually anything on planet earth in Lxd. 

The script configures your Kubuntu host as a Docker/LXD server with Ansible CLI ready to go, along with the linux kernel dummy module [(see kernel docs; for k8s)](https://www.kernel.org/doc/html/latest/).


## Quick Start

**WARNING: (THIS SCRIPT IS UNSAFE!  NEVER USE IN PRODUCTION!), 🌌.** 

* Ensure your host is backed up. Ensure it is a modern Ubuntu release.

* Launch the bash and follow the prompts
```bash
   ./bldub.sh
```
