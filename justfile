[working-directory: './clanbomber-2.1.1']
configure:
	./configure --with-boost=$BOOST_ROOT --with-boost-libdir=$BOOST_LIBRARYDIR

patch:
	patch -p1 -d ./clanbomber-2.1.1 < ./patches/clanbomber-2.1.1-modernize.patch
