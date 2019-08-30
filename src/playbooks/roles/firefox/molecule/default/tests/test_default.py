import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']
).get_hosts('all')


def test_command_existence(host):
    assert host.exists("firefox")


def test_screenshot(host):
    tmpdir = host.check_output("mktemp -d")

    host.check_output(f"cd {tmpdir} && firefox --screenshot 'about:robots'")
    screenshot = host.file(f"{tmpdir}/screenshot.png")
    assert screenshot.exists
    assert screenshot.is_file
    assert screenshot.size > 0
