DOCKERIMAGE:=.

TAG = emscripten:0.1

builddocker:
	docker build \
		-t $(TAG) \
		docker

test: clean test_c webserver

test_c: compute
	./compute input.json

webserver: compute.js 
	python2 -m SimpleHTTPServer

compute: compute.cpp
	g++ $^ -o $@

compute.js: compute.cpp
	docker run --rm -v $(shell pwd):/src -u $(shell id -u):$(shell id -g) $(TAG) \
	emcc -s WASM=1 --no-entry compute.cpp \
	-I/nlopt-2.6.2/src/algs/ags \
	-I/nlopt-2.6.2/src/algs/auglag \
	-I/nlopt-2.6.2/src/algs/bobyqa \
	-I/nlopt-2.6.2/src/algs/cdirect \
	-I/nlopt-2.6.2/src/algs/cobyla \
	-I/nlopt-2.6.2/src/algs/cquad \
	-I/nlopt-2.6.2/src/algs/crs \
	-I/nlopt-2.6.2/src/algs/direct \
	-I/nlopt-2.6.2/src/algs/esch \
	-I/nlopt-2.6.2/src/algs/isres \
	-I/nlopt-2.6.2/src/algs/luksan \
	-I/nlopt-2.6.2/src/algs/mlsl \
	-I/nlopt-2.6.2/src/algs/mma \
	-I/nlopt-2.6.2/src/algs/neldermead \
	-I/nlopt-2.6.2/src/algs/newuoa \
	-I/nlopt-2.6.2/src/algs/praxis \
	-I/nlopt-2.6.2/src/algs/slsqp \
	-I/nlopt-2.6.2/src/algs/stogo \
	-I/nlopt-2.6.2/src/algs/subplex \
	-I/nlopt-2.6.2/src/api \
	-I/nlopt-2.6.2/src/util \
	-I/nlopt-2.6.2/build \
	/nlopt-2.6.2/src/api/optimize.c \
	/nlopt-2.6.2/src/api/options.c \
	/nlopt-2.6.2/src/api/f77api.c \
	/nlopt-2.6.2/src/api/general.c \
	/nlopt-2.6.2/src/api/deprecated.c \
	/nlopt-2.6.2/src/util/timer.c \
	/nlopt-2.6.2/src/util/mt19937ar.c \
	/nlopt-2.6.2/src/util/sobolseq.c \
	/nlopt-2.6.2/src/util/rescale.c \
	/nlopt-2.6.2/src/util/stop.c \
	/nlopt-2.6.2/src/util/qsort_r.c \
	/nlopt-2.6.2/src/util/redblack.c \
	/nlopt-2.6.2/src/util/redblack_test.c \
	/nlopt-2.6.2/src/util/sobolseq_test.c \
	/nlopt-2.6.2/src/util/mt19937ar_test.c \
	/nlopt-2.6.2/src/util/nlopt-getopt.c \
	/nlopt-2.6.2/src/algs/auglag/auglag.c \
	/nlopt-2.6.2/src/algs/cquad/cquad.c \
	/nlopt-2.6.2/src/algs/crs/crs.c \
	/nlopt-2.6.2/src/algs/luksan/mssubs.c \
	/nlopt-2.6.2/src/algs/luksan/plip.c \
	/nlopt-2.6.2/src/algs/luksan/plis.c \
	/nlopt-2.6.2/src/algs/luksan/pssubs.c \
	/nlopt-2.6.2/src/algs/luksan/pnet.c \
	/nlopt-2.6.2/src/algs/neldermead/sbplx.c \
	/nlopt-2.6.2/src/algs/neldermead/nldrmd.c \
	/nlopt-2.6.2/src/algs/cobyla/cobyla.c \
	/nlopt-2.6.2/src/algs/newuoa/newuoa.c \
	/nlopt-2.6.2/src/algs/mlsl/mlsl.c \
	/nlopt-2.6.2/src/algs/subplex/subplex.c \
	/nlopt-2.6.2/src/algs/mma/ccsa_quadratic.c \
	/nlopt-2.6.2/src/algs/mma/mma.c \
	/nlopt-2.6.2/src/algs/cdirect/cdirect.c \
	/nlopt-2.6.2/src/algs/cdirect/hybrid.c \
	/nlopt-2.6.2/src/algs/stogo/tstc.c \
	/nlopt-2.6.2/src/algs/praxis/praxis.c \
	/nlopt-2.6.2/src/algs/esch/esch.c \
	/nlopt-2.6.2/src/algs/isres/isres.c \
	/nlopt-2.6.2/src/algs/slsqp/slsqp.c \
	/nlopt-2.6.2/src/algs/bobyqa/bobyqa.c \
	/nlopt-2.6.2/src/algs/direct/DIRserial.c \
	/nlopt-2.6.2/src/algs/direct/DIRsubrout.c \
	/nlopt-2.6.2/src/algs/direct/DIRparallel.c \
	/nlopt-2.6.2/src/algs/direct/tstc.c \
	/nlopt-2.6.2/src/algs/direct/direct_wrap.c \
	/nlopt-2.6.2/src/algs/direct/DIRect.c \
	/nlopt-2.6.2/build/CMakeFiles/3.16.3/CompilerIdC/CMakeCCompilerId.c \
	/nlopt-2.6.2/build/CMakeFiles/CheckTypeSize/SIZEOF_UNSIGNED_INT.c \
	/nlopt-2.6.2/build/CMakeFiles/CheckTypeSize/SIZEOF_UNSIGNED_LONG.c \
	/nlopt-2.6.2/build/CMakeFiles/CheckTypeSize/SIZEOF_UINT32_T.c \
	/nlopt-2.6.2/build/fpclassify.c \
	 -o compute.html  \
	-s EXPORTED_RUNTIME_METHODS="['cwrap']" -s EXPORTED_FUNCTIONS="['_compute']"

clean:
	rm -rf compute.wasm compute.html compute.js compute 

.PHONY:
	clean test test_c webserver builddocker
