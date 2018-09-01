# ansible-playbook

[![Build Status](https://travis-ci.org/km45/ansible-playbook.svg?branch=master)](https://travis-ci.org/km45/ansible-playbook)

## How to use

Add below settings to `Vagrantfile` and run vagrant provisioning.

```ruby
config.vm.provision "km45", type: "ansible_local" do |ansible|
  ansible.playbook = "km45-playbooks/site.yml"
  ansible.compatibility_mode = "2.0"
  # ansible.verbose = "vvv"
end
```
