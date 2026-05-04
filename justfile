configure:
	./configure --with-boost=$BOOST_ROOT --with-boost-libdir=$BOOST_LIBRARYDIR

download:
	curl -LO https://download.savannah.nongnu.org/releases/clanbomber/clanbomber-2.1.1.tar.lzma

unpack:
	tar --strip-components=1 -xvf ./clanbomber-2.1.1.tar.lzma

build:
	make -j
