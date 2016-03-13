#!/usr/bin/env bash

sudo apt-get -y install git
wget -qO- https://raw.github.com/creationix/nvm/master/install.sh | sh
source ~/.nvm/nvm.sh

echo "$PATH"

nvm install 5.3.0
nvm use 5.3.0
git clone https://github.com/quantumfoam/DVNA.git
cd DVNA/
npm set progress=false
npm install
# node dvna.js

