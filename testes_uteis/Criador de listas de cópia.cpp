#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <conio2.h>
#include <windows.h>
#define TEMPCHAR 300
#define NUMCICLRESET 1
void tamanho_tela(int larg, int alt)  // Função para definir o tamanho da tela (copia do professor) 
{
    HANDLE console = GetStdHandle(STD_OUTPUT_HANDLE);
    COORD consoleSize;
    consoleSize.X = larg;
    consoleSize.Y = alt;
    SetConsoleScreenBufferSize(console, consoleSize);
    ShowWindow(GetForegroundWindow(), SW_MAXIMIZE );
}
int main(void){
    unsigned char dig=0;
    char tempchar[TEMPCHAR]={0};
    int positempchar=0, cont=0, set=3;
    FILE* destino;
    if((destino=fopen("lista.bat", "a"))==NULL){//ancontrou o arquivo
         printf("NAO FOI POSSIVEL INICIAR O APLICATIVO...");
         getch();
         exit(0);
    }
    printf("\n\n\nARRASTE PARA CA OS ARQUIVOS A SEREM LISTADOS");
    fprintf(destino, "\n@echo off");
    fprintf(destino, "\nset /p destino=***Informe o destino---");
    fprintf(destino, "\nmkdir %cdestino%c", 37, 37);
    while(1){
         gotoxy(1,1);printf("                                                                      ");
         gotoxy(1,1);printf("%s", tempchar);
         if(kbhit()){
              dig=getch();
              cont=0;
              switch(dig){
                   case 27://pessoa pressiona esc
                        fclose(destino);
                        exit(0);
                        break;
                   default:
                        if(positempchar<TEMPCHAR){
                             tempchar[positempchar]=dig;
                             positempchar++;
                        }
                        break;
              }
         }
         if(cont>1){
              textcolor(186);
              gotoxy(1,(set++)); printf("\n%s", tempchar);
              textcolor(15);
              fprintf(destino, "\nxcopy %s %cdestino%c", tempchar, 37, 37);
              positempchar=0;
              while(positempchar<TEMPCHAR){
                   tempchar[positempchar]=0;
                   positempchar++;
              }
              positempchar=0;
              cont=-1;
         }
         if(cont!=-1) cont++;
    }
}
