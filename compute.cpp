//#include <iostream>
#include <stdio.h>
#include <emscripten/emscripten.h>

#define JSON_NO_IO
#define JSON_NOEXCEPTION
#include "json.hpp"
#include "glm/glm.hpp"

typedef long int i32_;

using namespace glm;
using namespace nlohmann;


void cpp_compute(uint8_t* buffer, int l)
{
    //printf((char*)buffer);

    //Parse json
    auto input = json::parse(buffer);    
    //printf(input.dump(4).c_str());
    
    //Read input into GLM variables
    vec3 a(input["a"]["x"],input["a"]["y"],input["a"]["z"]);
    //printf("a %f %f %f\n", a.x, a.y, a.z);
    vec3 b(input["b"]["x"],input["b"]["y"],input["b"]["z"]);
    //printf("b %f %f %f\n", b.x, b.y, b.z);
    
    //Do computation    
    vec3 c = cross(a,b);
    //printf("c %f %f %f\n", c.x, c.y, c.z);
    
    //Construct output
    json output = {};
    output["c"] = {};
    output["c"]["x"] = c.x;
    output["c"]["y"] = c.y;
    output["c"]["z"] = c.z;
    
    //Serialize output
    //printf(output.dump(4).c_str());
    sprintf((char*)buffer, "%s", output.dump(4).c_str());    
}
  
extern "C" {
EMSCRIPTEN_KEEPALIVE    void compute(uint8_t* buffer, int l) 
    {
        cpp_compute(buffer, l);    
    }

#if 0
    #define BUFFER_SIZE (1024*1024)
    int main(int argc, char* argv[])
    {
    if(argc != 2 || strcmp(argv[1], "-h") == 0)
    {
    printf("usage: %s input.json\n", argv[0]);
    exit(1);
    }

    //Input and output json must be below this size!!!
    uint8_t buffer[BUFFER_SIZE];

    FILE* f = fopen(argv[1], "r");    
    int n = fread(buffer, 1, BUFFER_SIZE, f);
    fclose(f);    

    cpp_compute(buffer, n);

    printf("%s", (char*)buffer);

    return 0;
    }
#endif
}


#if 0
int main() {
    printf("Hello World\n");
}
#endif

#ifdef __cplusplus
extern "C" {
#endif

EMSCRIPTEN_KEEPALIVE void myFunction(int argc, char ** argv) {
    printf("MyFunction Called\n");
}

#ifdef __cplusplus
}
#endif
