#!/bin/bash

# Copy Yap's examples into docker volume (so they can be accessed from the host)
cp -r /usr/share/yapp/examples/ yap-examples/

# Symlink the examples directory to $HOME/yap-examples, so Yap finds them.
ln -s /root/files/yap-examples /root/yap-examples

# Run the HRC2 example.
cd yap-examples/hrc2 || exit 1
./run.sh
./run.sh -c -r