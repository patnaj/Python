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
