#include <iostream>
#include "md5.h"

using std::cout; using std::endl;

int main(int argc, char* argv[])
{
    if (argc > 1){
        cout << "md5 de " << argv[1] << ": " << md5(argv[1]) << endl;
    }
    
    return 0;
}