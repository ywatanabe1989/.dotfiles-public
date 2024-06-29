PYTHON_VERSION=3.11

dnf -y install \
    python"$PYTHON_VERSION" \
    python"$PYTHON_VERSION"-devel \
    python"$PYTHON_VERSION"-tkinter \
    python"$PYTHON_VERSION"-pip

ln -sf `which python"$PYTHON_VERSION"` /usr/bin/python3
ln -sf /usr/bin/python"$PYTHON_VERSION" /usr/bin/python3
ln -sf /usr/bin/python3 /usr/bin/python

echo -e "\n################################################################################\n"
which python"$PYTHON_VERSION"
python"$PYTHON_VERSION" --version

which python3
python3 --version

which python
python --version
echo -e "\n################################################################################\n"
