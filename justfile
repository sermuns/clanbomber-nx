configure:
	./configure --with-boost=$BOOST_ROOT --with-boost-libdir=$BOOST_LIBRARYDIR

build:
	make -j
