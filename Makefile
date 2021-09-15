DOCKERIMAGE:=emscripten/emsdk

test: test_c

test_c: compute
	./compute input.json

#test_node: compute.wasm
#	node ???

webserver: 
	python2 -m SimpleHTTPServer

compute: compute.cpp
	g++ $^ -o $@

REMOVED = docker run --rm -v $(shell pwd):/src -u $(shell id -u):$(shell id -g) $(DOCKERIMAGE)

compute.html: compute.cpp
	emcc -s WASM=1 --no-entry $< -o $@  \
	-s EXPORTED_RUNTIME_METHODS="['cwrap']" -s EXPORTED_FUNCTIONS="['_compute']"

interactive: 
	docker run -it --rm -v $(shell pwd):/src -u $(shell id -u):$(shell id -g) $(DOCKERIMAGE)

clean:
	rm -rf compute compute.wasm

.PHONY:
	clean test test_c webserver
