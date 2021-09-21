FROM emscripten/emsdk:latest

WORKDIR /

RUN wget https://github.com/stevengj/nlopt/archive/v2.6.2.tar.gz
RUN tar -xzvf v2.6.2.tar.gz
RUN cd nlopt-2.6.2 && mkdir build && cd build && cmake .. && make && sudo make install && ls

WORKDIR /src
RUN apt update && apt install mc nano -y