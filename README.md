# ansible for ubuntu

## How to use

1. Provision from host environment
1. Provision in guest environment

### Provision from host environment

Add below settings to `Vagrantfile` and run vagrant provisioning.

```ruby
config.vm.provision "km45-ansible", type: "ansible_local" do |ansible|
  ansible.playbook = "ansible/host.yml"
end
```

### Provision in guest environment

Vagrant provisioning can not complete some tasks,
so run them in guest environment.

[CAUSION] Run them in guest environment, not in ssh connection.

```console
$ ansible-playbook -c local guest.yml
```

## For developers

I recommend adding below settings.

```ruby
ansible.verbose = "vvv"
```
