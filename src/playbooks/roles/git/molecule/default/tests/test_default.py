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


def test_git_ignore(host):
    with host.sudo("vagrant"):
        assert host.check_output("whoami") == "vagrant"

        tmpdir = host.check_output("mktemp -d")

        host.check_output(f"cd {tmpdir} && git init")

        assert host.check_output(
            (f"cd {tmpdir}"
             " && HOME=/home/vagrant git ls-files --others --exclude-standard"
             " | wc -l")) == "0"

        host.check_output(f"cd {tmpdir} && touch compile_commands.json")

        assert host.check_output(
            (f"cd {tmpdir}"
             " && HOME=/home/vagrant git ls-files --others --exclude-standard"
             " | wc -l")) == "0"

        host.check_output(f"cd {tmpdir} && mkdir .vscode")
        host.check_output(f"cd {tmpdir}/.vscode && touch hoge")

        assert host.check_output(
            (f"cd {tmpdir}"
             " && HOME=/home/vagrant git ls-files --others --exclude-standard"
             " | wc -l")) == "0"

        host.check_output(f"cd {tmpdir} && touch README.md")

        assert host.check_output(
            (f"cd {tmpdir}"
             " && HOME=/home/vagrant git ls-files --others --exclude-standard"
             " | wc -l")) == "1"
