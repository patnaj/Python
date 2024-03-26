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