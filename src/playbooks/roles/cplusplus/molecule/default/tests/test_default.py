import os
import textwrap

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']
).get_hosts('all')


def test_gplusplus(host):
    tmpdir = host.check_output("mktemp -d")

    cpp_code = textwrap.dedent(r"""
    #include <iostream>
    int main() {
        std::cout << "Hello, world!" << std::endl;
        return 0;
    }
    """)

    host.check_output(
        f"cd {tmpdir} && cat << EOS > source.cc\n {cpp_code}\nEOS")

    host.check_output(f"cd {tmpdir} && g++ source.cc")

    expected = "Hello, world!"
    actual = host.check_output(f"cd {tmpdir} && ./a.out")
    assert expected == actual
