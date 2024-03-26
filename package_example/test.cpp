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