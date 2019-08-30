import os

import parse
import semver

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']
).get_hosts('all')


def test_command_existence(host):
    assert host.exists("git")


def test_git_version(host):
    cmd = host.run("git version")
    assert cmd.rc == 0

    result = parse.parse("git version {version}\n", cmd.stdout)
    assert result is not None

    assert semver.match(result['version'], ">=2.23.0")
    assert semver.match(result['version'], "<3.0.0")
