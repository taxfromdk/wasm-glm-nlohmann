//#include <iostream>
#include <stdio.h>

#ifdef __EMSCRIPTEN__
#include <emscripten/emscripten.h>
#endif

#include "json.hpp"
#include "glm/glm.hpp"



using namespace glm;

#include "math.glsl"

using namespace nlohmann;


uint8_t * cpp_compute(uint8_t* buffer, int l)
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
    vec3 c = custom_function(a,b);
    //printf("c %f %f %f\n", c.x, c.y, c.z);
    
    //Simulate numerical process that will take a million iterations
    vec3 z(0.0,0.0,0.0);
    for(int i=0;i<1000000;i++)
    {
        z = z + ((c - z) * 0.00001f);
        if(i%100000==0)
        {
            printf("%d %0.2f %0.2f %0.2f \n", i, z.x, z.y, z.z);
        }        
    }
    c = z;

    //Construct output
    json output = {};
    output["c"] = {};
    output["c"]["x"] = c.x;
    output["c"]["y"] = c.y;
    output["c"]["z"] = c.z;
    
    //Serialize output
    //printf(output.dump(4).c_str());
    sprintf((char*)buffer, "%s", output.dump(4).c_str());    
    return buffer;
}
  
extern "C" 
{
    #ifdef __EMSCRIPTEN__
    EMSCRIPTEN_KEEPALIVE    uint8_t* compute(uint8_t* buffer, int l) 
    {
        return cpp_compute(buffer, l);    
    }
    #endif

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
}


