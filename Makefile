all: build ocamlmoe

dev:
	dune build --dev -j16

build:
	dune build

ocamlmoe:
	ln -s _build/install/default/bin/$@ ./$@

clean:
	dune clean

test:
	dune runtest

preprocess:
	dune build @preprocess

promote:
	dune promote

.PHONY: all build dev clean test promote
