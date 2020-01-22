import os
import textwrap

import parse
import semver

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']
).get_hosts('all')


def test_gplusplus(host):
    assert host.exists("g++")

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


def test_gdb(host):
    assert host.exists("gdb")

    tmpdir = host.check_output("mktemp -d")

    cpp_code = textwrap.dedent(r"""
    #include <iostream>
    #include <vector>
    int main() {
        std::vector<int> a = {2, 3, 1, 4, 5};
        int max = a[0];
        for (auto i = 1u; i < a.size(); ++i) {
            if (a[i] > max) {
                max = a[i];
            }
        }
        std::cout << "max = " << max << std::endl;
        return 0;
    }
    """)

    host.check_output(
        f"cd {tmpdir} && cat << EOS > source.cc\n {cpp_code}\nEOS")

    gdb_command = textwrap.dedent(r"""
    set pagination off
    b main
    r
    b 7
    b 9
    c
    p max
    c
    p max
    n
    p max
    c
    p max
    n
    p max
    d 2
    b 12
    c
    p max
    q
    """)

    host.check_output(
        f"cd {tmpdir} && cat << EOS > gdb.command\n {gdb_command}\nEOS")

    host.check_output(f"cd {tmpdir} && g++ -std=c++11 -g source.cc")

    expected = [
        '$1 = 2', '$2 = 2', '$3 = 3', '$4 = 3', '$5 = 4', '$6 = 4'
    ]
    gdb_stdout = host.check_output(
        f"cd {tmpdir} && gdb ./a.out --command=gdb.command")
    actual = [
        line for line in gdb_stdout.splitlines() if line.startswith('$')
    ]
    assert expected == actual


def test_cmake(host):
    assert host.exists("cmake")

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


def test_ninja_by_cmake(host):
    assert host.exists("cmake")

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

    host.check_output(f"cd {tmpdir} && cmake -G Ninja . && cmake --build .")

    expected = "Hello, world!"
    actual = host.check_output(f"cd {tmpdir} && ./test2")
    assert expected == actual


def test_clang_format(host):
    assert host.exists("clang-format")

    result = parse.parse(
        "clang-format version {version}",
        host.check_output("clang-format --version")
    )
    assert result is not None

    version = result['version'].split('-')[0]
    assert semver.match(version, ">=10.0.0")
