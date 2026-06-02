# GSA Installer

Tiny public bootstrap installer for GSA Brain.

This repo contains no GSA Brain methodology files. It only installs the private GSA Brain repo for users who already have read-only access.

## Install

Run these two commands:

```bash
curl -fsSL https://raw.githubusercontent.com/chasepkelly/gsa-installer/main/install.sh -o gsa-install.sh
bash gsa-install.sh
```

The installer asks for a workspace name and install location.

If you want to inspect it first:

```bash
curl -fsSL https://raw.githubusercontent.com/chasepkelly/gsa-installer/main/install.sh -o gsa-install.sh
less gsa-install.sh
bash gsa-install.sh
```
