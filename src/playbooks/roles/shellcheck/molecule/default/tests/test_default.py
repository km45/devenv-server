import os
import textwrap

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']
).get_hosts('all')


def test_command_existence(host):
    assert host.exists("shellcheck")


def test_return_code(host):
    tmpdir = host.check_output("mktemp -d")

    bad_script = textwrap.dedent(r"""
    #!/bin/bash
    echo $1
    """).lstrip()

    host.check_output(
        f"cd {tmpdir} && cat << 'EOS' > bad_script.sh\n{bad_script}\nEOS")

    result = host.run(f"cd {tmpdir} && shellcheck bad_script.sh")
    assert result.rc == 1

    good_script = textwrap.dedent(r"""
    #!/bin/bash
    echo "$1"
    """).lstrip()

    host.check_output(
        f"cd {tmpdir} && cat << 'EOS' > good_script.sh\n{good_script}\nEOS")

    result = host.run(f"cd {tmpdir} && shellcheck good_script.sh")
    assert result.rc == 0
