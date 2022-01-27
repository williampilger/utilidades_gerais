#include "md5_dll.h"
#include "md5.h"

#include <iostream>
#include <string>
#include <windows.h>

using  std::string;

void md5Calc(const char* str, char* out_str){
    //out_str = (char*)malloc(sizeof(char) * 16);
    string temp = md5(string(str)).c_str();
    strcpy(out_str, temp.c_str());
}


/*

#include "md5_dll.h"
#include "md5.h"

#include <windows.h>
#include <iostream>
#include <string>

int md5Calc(const char* str, char* out_str){
    out_str = (char*)md5((std::string)str).c_str();
	return 0;
}

*/