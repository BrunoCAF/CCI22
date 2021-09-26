#include <stdio.h>
#include <stdlib.h>

int main() {
    float feps = 1.0f;
    while(feps/2.0f + 1.0f > 1.0f){
        feps /= 2.0f;
    }
    
    
    double deps = 1.0;
    while(deps/2.0 + 1.0 > 1.0){
        deps /= 2.0;
    }
    
    printf("Epsilon Float:  %.50f\nEpsilon Double: %.50lf\n\n\n", feps, deps);
    
    printf("size float       %2ld \n", sizeof(float));
    printf("size double      %2ld \n" , sizeof(double));
    printf("size long double %2ld \n" , sizeof(long double));
    
    return 0;
}

