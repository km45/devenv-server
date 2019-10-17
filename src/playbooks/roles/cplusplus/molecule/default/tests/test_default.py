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


def test_gdb_existence(host):
    assert host.exists("gdb")


def test_cmake(host):
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

    cmake_lists = textwrap.dedent(r"""
    cmake_minimum_required(VERSION 3.0)
    project(test1)
    add_executable(test2 source.cc)
    """)

    host.check_output(
        f"cd {tmpdir} && cat << EOS > CMakeLists.txt\n {cmake_lists}\nEOS")

    host.check_output(f"cd {tmpdir} && cmake . && cmake --build .")

    expected = "Hello, world!"
    actual = host.check_output(f"cd {tmpdir} && ./test2")
    assert expected == actual
