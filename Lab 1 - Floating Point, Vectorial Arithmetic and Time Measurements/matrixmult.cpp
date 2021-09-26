#include <windows.h>
#include <cstdio>
#include <cstdlib>
#include <iostream>
#include <cstdint>

class Watch{
    public:
        Watch(){
            LARGE_INTEGER li;
            if(!QueryPerformanceFrequency(&li)){
                std::cout << "QueryPerformanceFrequency failed!\n";
                return;
            }

            mPCFreq = static_cast<double>(li.QuadPart)/1000.0;

            QueryPerformanceCounter(&li);
            mCounterStart = li.QuadPart;
        }

        // Retorna o tempo em milisegundos desde que o
        // objeto Watch foi criado.
        double getCounter(){
            LARGE_INTEGER li;
            QueryPerformanceCounter(&li);
            return static_cast<double>(li.QuadPart - mCounterStart)/mPCFreq;
        }

    private:
        uint64_t mCounterStart;
        double mPCFreq;
};



double x10[10][10], y10[10][10], z10[10][10];
double x100[100][100], y100[100][100], z100[100][100];
double x1000[1000][1000], y1000[1000][1000], z1000[1000][1000];
double t10, t100, t1000;

int main() {
    for(int i = 0; i < 10; i++) 
        for(int j = 0; j < 10; j++) 
            y10[i][j] = x10[i][j] = 1;
    
    for(int i = 0; i < 100; i++) 
        for(int j = 0; j < 100; j++) 
            y100[i][j] = x100[i][j] = 1;
    
    for(int i = 0; i < 1000; i++) 
        for(int j = 0; j < 1000; j++) 
            y1000[i][j] = x1000[i][j] = 1;
    
    
    Watch counter10;
    for(int i = 0; i < 10; i++){
        for(int j = 0; j < 10; j++){
            for(int k = 0; k < 10; k++){
                z10[i][j] += x10[i][k]*y10[k][j];
            }
        }
    }
    t10 = counter10.getCounter();


    Watch counter100;
    for(int i = 0; i < 100; i++){
        for(int j = 0; j < 100; j++){
            for(int k = 0; k < 100; k++){
                z100[i][j] += x100[i][k]*y100[k][j];
            }
        }
    }
    t100 = counter100.getCounter();

    
    Watch counter1000;
    for(int i = 0; i < 1000; i++){
        for(int j = 0; j < 1000; j++){
            for(int k = 0; k < 1000; k++){
                z1000[i][j] += x1000[i][k]*y1000[k][j];
            }
        }
    }
    t1000 = counter1000.getCounter();
    
    printf("T10: %.20g milisegundos\n", t10);
    printf("T100: %.20g milisegundos\n", t100);
    printf("T1000: %.20g milisegundos\n", t1000);
    
    return 0;
}