import setuptools

with open("README.md", "r", encoding="utf-8") as fh:
    long_description = fh.read()

setuptools.setup(
    version="0.0.1",
    long_description=long_description,
    long_description_content_type="text/markdown",
    url="https://github.com/yuyatinnefeld/der_die_das",
    project_urls={
        "Bug Tracker": "https://github.com/yuyatinnefeld/der_die_das/issues",
    },
    packages=['der_die_das'],
    python_requires=">=3.7",
)