#ifndef MATH_GLSL
#define MATH_GLSL

//These decorators are needed to be able to juggle glsl definitions to a format that can be 
//accepted by cuda, glsl and other compilers. (work in progress)

#ifdef __NVCC__
#define CUD(x) x
#else
#define CUD(x)
#endif

#ifdef HEADERONLY
#define HO(x) ;
#else
#define HO(x) x
#endif


vec3 CUD(__device__ __forceinline__) custom_function(vec3 a, vec3 b)
HO(
    {
        return cross(a,b);
    }
)

#endif
