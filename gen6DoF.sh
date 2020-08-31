#!/bin/bash
echo 'Start'
echo 'creating 6DoF.dat file'
cd gen6DoF/
wmake
mv $FOAM_USER_APPBIN/gen6DoF .
./gen6DoF
cd ..
cp -r gen6DoF/6DoF.dat .
echo '6DoF.dat file is created'

