# devenv-server

[![CI](https://github.com/km45/devenv-server/actions/workflows/ci.yml/badge.svg)](https://github.com/km45/devenv-server/actions/workflows/ci.yml)

1. Create WSL `Ubutun 22.04` environment.
1. Install ansible and provision as follows.

```sh
sudo apt-add-repository ppa:ansible/ansible
sudo apt install --no-install-recommends ansible
ansible-playbook --ask-become-pass site.yml
```

## multiple WSL environment

If you want to create multiple environment, use `wsl --export` and `wsl --import` as follows.

```sh
wsl --export Ubuntu-22.04 ./distributions/Ubuntu-22.04.tar
wsl --import wsl-jammy0x ./wsl-jammy0x/ ./distributions/Ubuntu-22.04.tar
```

Edit `/etc/wsl.conf` in the WSL environment to change the login user from `root`.

```conf
[user]
default=username
```

Use `wsl --terminate` to restart the distribution to reflect the configuration changes.

## use dnsTunneling option if necessary

Edit `~/.wslconfig` in Windows environment.

```conf
[wsl2]
dnsTunneling=true
```

## change hostname if necessarry

Edit `/etc/wsl.conf` in the WSL environment.

```conf
[network]
hostname=wsl-jammy0x
```
