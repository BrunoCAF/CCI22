#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

/*----------Variaveis globais e definicoes----------*/
typedef char * tipelemento;
typedef tipelemento * vetor;

//contadores de comparacoes
long int contadorMerge = 0;

vetor Temp;

/*---------------------Funcoes----------------------*/
void Merge(vetor V, int ini, int fim){
    int med, i, j, k;
    
    med = (ini + fim)/2;
    j = ini;
    k = med + 1;
    i = ini;
    
    while(j <= med && k <= fim){
        if(strcmp(V[j], V[k]) <= 0)
            strcpy(Temp[i++], V[j++]);
        else
            strcpy(Temp[i++], V[k++]);
    }
    
    while(j <= med)
        strcpy(Temp[i++], V[j++]);
    
    while(k <= fim)
        strcpy(Temp[i++], V[k++]);
    
    for(i = ini; i <= fim; i++)
        strcpy(V[i], Temp[i]);
}

void MergeSort(vetor V, int ini, int fim){
    int med;
    if (ini < fim){
        med = (ini + fim)/2;
        MergeSort(V, ini, med);
        MergeSort(V, med + 1, fim);
        Merge(V, ini, fim);
    }
}
/*--------------------------------------------------*/
int main(){



    return 0;
}
