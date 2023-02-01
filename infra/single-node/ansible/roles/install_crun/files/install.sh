echo -e "Building and installing crun"
cd crun || exit
./autogen.sh
./configure --with-wasmedge
make
sudo make install
