# sosreport

Project to create report via sosreport tool.
Note: python bdist command for setup module does not configure requires to the spec file.

build:
```bash
# build rpm without requires packages
python setup.py bdist --format=rpm

# build rpm with requires packages
make rpm
```