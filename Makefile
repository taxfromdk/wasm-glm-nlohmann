DOCKERIMAGE:=emscripten/emsdk

test: clean test_c webserver

test_c: compute
	./compute input.json

webserver: compute.js 
	python2 -m SimpleHTTPServer

compute: compute.cpp
	g++ $^ -o $@

compute.js: compute.cpp
	docker run --rm -v $(shell pwd):/src -u $(shell id -u):$(shell id -g) $(DOCKERIMAGE) \
	emcc -s WASM=1 --no-entry compute.cpp -o compute.html  \
	-s EXPORTED_RUNTIME_METHODS="['cwrap']" -s EXPORTED_FUNCTIONS="['_compute']"

clean:
	rm -rf compute.wasm compute.html compute.js compute 

.PHONY:
	clean test test_c webserver
