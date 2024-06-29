sudo apt-get --purge autoremove mu4e
sudo apt-get --purge autoremove mu
sudo apt-get --purge autoremove isync


# http://blog.onodera.asia/2020/06/how-to-use-google-g-suite-oauth2-with.html
## isync
cd /tmp
tar xvf isync-1.4.4.tar.gz
cd isync-1.4.4
./configure --prefix=/opt/isync-1.4.4
make -j 12
sudo make install -j 12
# export PATH=$PATH:/opt/isync-1.4.4/bin

## cyrus-sasl-xoauth2
sudo apt-get install libsasl2-dev
cd /tmp
wget https://github.com/moriyoshi/cyrus-sasl-xoauth2/archive/refs/tags/v0.2.tar.gz
tar xvf v0.2.tar.gz
cd cyrus-sasl-xoauth2-0.2
./autogen.sh
./configure --prefix=/opt/cyrus-sasl-xoauth2-0.2
make -j 12
sudo make install -j 12
# export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib

# Libraries have been installed in:
#    /usr/lib/sasl2

# If you ever happen to want to link against installed libraries
# in a given directory, LIBDIR, you must either use libtool, and
# specify the full pathname of the library, or use the '-LLIBDIR'
# flag during linking and do at least one of the following:
#    - add LIBDIR to the 'LD_LIBRARY_PATH' environment variable
#      during execution
#    - add LIBDIR to the 'LD_RUN_PATH' environment variable
#      during linking
#    - use the '-Wl,-rpath -Wl,LIBDIR' linker flag
#    - have your system administrator add LIBDIR to '/etc/ld.so.conf'

## msmtp
sudo apt-get install msmtp





## mu-1.6.0
cd tmp
wget https://github.com/djcb/mu/archive/refs/tags/1.6.10.tar.gz
tar xvf 1.6.10.tar.gz
cd mu-1.6.10
./configure --prefix=/opt/mu-1.6.0
make -j 12
sudo make install -j 12


## /opt/mu-1.6.10/share/emacs/site-lisp/mu4e/


sudo apt-get -y install libgmime-3.0-dev libxapian-dev
# # erors were encountered while processing mu4e


# # # get emacs 25 or higher if you don't have it yet
# # $ sudo apt-get install emacs

# optional
sudo apt-get -y install guile-2.2-dev html2text xdg-utils

# # # optional: only needed for msg2pdf and mug (toy gtk+ frontend)
# sudo apt-get install libwebkitgtk-3.0-dev

sudo apt install -y isync
sudo apt install -y maildir-utils
sudo apt install -y mu4e

# https://www.oit.ac.jp/rd/labs/kobayashi-lab/~yagshi/mu4e.html


mu init \
   --maildir=$HOME/Mail \
   --my-address=wataning11@gmail.com \
   --muhome=$HOME/.mu

mu index --muhome=$HOME/.mu
