# ansible for ubuntu

## For vagrant provision

Add below settings to `Vagrantfile`.

```ruby
config.vm.provision "customized", type: "ansible_local" do |ansible|
  ansible.playbook = "ansible/customized.yml"
end
```

### For developers

I recommend adding below settings.

```ruby
ansible.verbose = "vvv"
```
