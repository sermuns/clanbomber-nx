configure:
	./configure --with-boost=$BOOST_ROOT --with-boost-libdir=$BOOST_LIBRARYDIR -C --cache-file=config.cache

build:
	make -j
