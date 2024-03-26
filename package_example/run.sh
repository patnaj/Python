#!/bin/bash

cat << EOT
Chyba najprostsza metoda tworzenia extensionów w C

# https://pybind11.readthedocs.io/en/stable/basics.html

# https://docs.python.org/3/extending/extending.html
# https://setuptools.pypa.io/en/latest/userguide/quickstart.html

# Przydatne extensiony do vs code:
#   Python C++ Debugger       v0.3.0 BeniBenj 
#   Python Extension Pack     v1.7.0 Don Jayamanne
#   Jupyter                   v2024.2.0 Microsoft microsoft.com

EOT

echo 'instalujemy wymagane pakiety'
python3 -m pip install -U pip wheel setuptools build pybind11



echo 'tworzymy plik konfiguracji'
cat << EOT > setup.py
from setuptools import setup, Extension
# from pybind11.setup_helpers import Pybind11Extension
try:
    from pybind11.setup_helpers import Pybind11Extension
except ImportError:
    from setuptools import Extension as Pybind11Extension


setup(
    name='package_example',
    version='0.0.1',
    setup_requires=["pybind11"],
    ext_modules=[
        Pybind11Extension("package_example.test", ["test.cpp"]),
        Pybind11Extension("package_example.obj", ["obj.cpp"]),
    ]
)
EOT



echo 'kod przykładowy z funkcjami'
cat << EOT > test.cpp
#include <Python.h>

#include <pybind11/pybind11.h>
#include <pybind11/stl.h>
#include <pybind11/iostream.h>

int add(int i, int j)
{
    return i + j + 4;
}

int _system(char *cmd)
{
    return system(cmd);
}

namespace py = pybind11;

PYBIND11_MODULE(test, m)
{
    m.attr("the_answer") = 42;
    m.doc() = "pybind11 example plugin"; // optional module docstring
    m.def("add", &add, "A function that adds two numbers");
    m.def("system", &_system,
          py::call_guard<py::scoped_ostream_redirect,
                         py::scoped_estream_redirect>(),
          "System cmd");
}
EOT



echo 'kod przykładowy z obiektem'
cat << EOT > obj.cpp
#include <Python.h>

#include <pybind11/pybind11.h>

struct Pet
{
    Pet(const std::string &name) : name(name) {}
    void setName(const std::string &name_) { name = name_; }
    const std::string &getName() const { return name; }

    std::string name;
};

PYBIND11_MODULE(obj, m)
{
    pybind11::class_<Pet>(m, "Pet")
        .def(pybind11::init<const std::string &>())
        .def("setName", &Pet::setName)
        .def("getName", &Pet::getName);
}
EOT


echo 'budowanie i instalacja '
#budowanie projektu
python3 -m build

#budowani i instalacja 
python3 -m pip install ./




echo 'kod przykładowy z obiektem'
mkdir tests
cd tests
cat << EOT > test.py
#%%
import package_example.test as test
print(dir(test))
print(test.the_answer)
print(test.add(1,2))
test.system("ls ../")


import package_example.obj as obj
print(dir(obj))
p = obj.Pet("kot")
print(dir(p))
print(p.getName())
# %%
EOT
python3 test.py
cd ..





