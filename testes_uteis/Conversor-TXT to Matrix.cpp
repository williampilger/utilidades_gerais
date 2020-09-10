#include <stdio.h>
#include <stdlib.h>
#include <conio2.h>
#include <string.h>
#include <windows.h>
#include <time.h>
//       pra que serve?
//
//           Você tem algum arquivo txt que quer transformar em uma matriz?
//           então este é o programa certo! ele divide tudo com vírgulas
int main(void)
{
    clrscr();
    char arquivo[200]={0};
    printf("digite o nome do arquivo para converter - ");
    scanf("%s", &arquivo);
    char string[300]={0};
    FILE *fluxo;
    if((fluxo=fopen(arquivo,"rt"))==NULL) exit(0);
    FILE *saida;
    int x=0;
    if((saida=fopen("saida.txt","wt"))==NULL) exit(0);
    while(fgets(string, 300, fluxo)){
         while(x<300){
              fprintf(saida,"%i,", atoi(string[x]));
              x++;
         }
         printf("\n");
         x=0;
    }
    fclose(fluxo);
    fclose(saida);
}

