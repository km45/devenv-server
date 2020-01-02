import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']
).get_hosts('all')


def test_pyenv_command_existence(host):
    with host.sudo("vagrant"):
        assert host.check_output("whoami") == "vagrant"

        assert host.check_output(
            ". /home/vagrant/.bashrc.d/pyenv.bashrc && which pyenv")
