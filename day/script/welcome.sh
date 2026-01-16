#!/bin/bash
# A simple script copied to the instance during the file+remote-exec demo
set -e

echo "Welcome to the Provisioner Demo" | sudo tee /tmp/welcome.txt
uname -a | sudo tee -a /tmp/welcome.txt
cat /tmp/welcome.txt
