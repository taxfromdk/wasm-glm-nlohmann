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

compute.wasm: compute.cpp
	docker run --rm -v $(shell pwd):/src -u $(shell id -u):$(shell id -g) $(DOCKERIMAGE) \
	emcc -s STANDALONE_WASM --no-entry $< -o $@  \
	-s EXPORTED_FUNCTIONS="['_compute']"

interactive: 
	docker run -it --rm -v $(shell pwd):/src -u $(shell id -u):$(shell id -g) $(DOCKERIMAGE)

clean:
	rm -rf compute compute.wasm

.PHONY:
	clean test test_c webserver
