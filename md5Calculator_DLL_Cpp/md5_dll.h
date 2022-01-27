#include <iostream>

#ifdef BUILD_DLL
    #define MD5_API __declspec(dllexport)
#else
    #define MD5_API __declspec(dllimport)
#endif

extern "C" void MD5_API md5Calc(const char* str, char* out_str);