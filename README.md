# devenv-server

[![CI](https://github.com/km45/devenv-server/actions/workflows/ci.yml/badge.svg)](https://github.com/km45/devenv-server/actions/workflows/ci.yml)

1. create WSL `Ubutun 22.04` environment
1. provision with ansible as follows

```sh
sudo apt-add-repository ppa:ansible/ansible
sudo apt install --no-install-recommends ansible
ansible-playbook --ask-become-pass site.yml
```
