#include <stdio.h>
#include <stdlib.h>
#include <conio2.h>
#include <string.h>
#include <windows.h>
#include <time.h>
//Constantes
#define MAXDIGDIRSISARQ 300//tamanho maximo de um diretório de arquivos do programa (arquivos internos) a ser pedido pelo programa.
#define MAXLARGTELA 200//maxima largura de tela
#define MAXALTTELA 200//maxima altura de tela

void tamanho_tela(int larg, int alt)  // Função para definir o tamanho da tela (copia do professor) 
{
    HANDLE console = GetStdHandle(STD_OUTPUT_HANDLE);
    COORD consoleSize;
    consoleSize.X = larg;
    consoleSize.Y = alt;
    SetConsoleScreenBufferSize(console, consoleSize);
    ShowWindow(GetForegroundWindow(), SW_MAXIMIZE );
}
int grafike(char arquivo[MAXDIGDIRSISARQ], int xi, int yi, int xf, int yf)//RECEBE: Caminho para acessar o arquivo de origem; posição x e y para inicio da figura; posição x e y final da imagem
//               MODO DE USAR (COMO CRIAR E CONFIGURAR O ARQUIVO COM A FIGURA)
//              
//               A primeira linha contem os parâmetros
//                    - as configurações são feitas de cinco em cinco digitos:
//                         -1º: caracter encontrado no arquivo
//                         -2º: caracter que deve ser escrito no lugar do encontrado (se for para manter, repita ele...)
//                         -3º, 4º e 5º: formam um numero de tres digitos que representa a cor que deve ser utilizada para escrever o caracter em questão.
//                    - OBS IMPORTANTE: a letra "o" sozinha ou seguida de espaço (somente se estiver no final), significa que será estipulada uma ordem de escrita, e não mais randômica (E DEVE OBRIGATORIAMENTE NAO ESTAR SEGUDA DE ESPAÇO).
//
//               Em seguida, vém a imagem...
//
//               Quando for encontrada a palavra "END" no início da linha, significa que terminou a imagem (SOMENTE SE "o" foi citado nas config da primeira linha)
//
//               Ordenando a escrita:
//                    - Para ordenar a escrita, são sempre utilizados dois numeros (três digitos) em cada linha, não divididos por nada. Onde:
//                          -1º: coordenada x (DA IMAGEM)
//                          -2º: coordenada y (DA IMAGEM)
//                          -* Ex: 005006 -> coordenada (5,6) da imagem
//                    - Para dar delays durante a escrita, usa-se a letra D seguida de um valor numérico de três digitos, em millisegundos. ex: D005 (delay de 5 millisegundos)
//                    - OBS IMPORTANTE: Caracteres não citados na ordem de escrita, não serão escritos!
//
//               Fim do arquivo quando acabam as linhas
{//retorna ZERO se o arquivo a ser lido nao foi acessível ou nao continha nada, ou não foi possivel fazer...
    FILE *fluxo;
    if((fluxo=fopen(arquivo,"rt"))==NULL) return(0);
    //fluxo=fopen("Logo.txt","rt");
    char string[MAXLARGTELA]={0};
    char matrix[MAXLARGTELA][MAXALTTELA]={0};//matriz que armazena a imagem a ser exibida
    int caractcor[255][3]={0};//no primeiro espaço, armazena o caracter encontrado no arquivo, no segundo o caracter a ser escrito, e no terceiro a cor.
    int mx=0, my=0;//localizam a matriz
    fgets(string, MAXDIGDIRSISARQ, fluxo);//pega a primeira linha do arquivo (que contém os parâmetros)//foi usada esta constante somente por ela ser maior
    int x=0,y=0, z=0;//variavel faz tudo
    char num[3]={0};//armazena os numeros digitados para cores
    int ord=0;//se estiver em 1, significa que o arquivo traz uma ordem de escrita de caracteres
    while(x<MAXDIGDIRSISARQ){
         switch(string[x]){
              case 32://espaço (somente é ignorado)
                   x++;
                   break;
              case 111://letra 'o', que se estiver sozinha, significa que o programa terá de seguir uma ordem de impressão de caracteres
                   if(string[x+1]==32){//se realmente estiver seguida de espaço
                        ord=1;
                        x=x+2;//pode pular dois, poir o o ja foi constado e o proximo é um espaço
                        break;
                   }//se não estiver seguida de espaço, continua como estava --POR ISSO NAO TEM BREAK ABAIXO
              default:
                   z=0;
                   while(z<255){
                        if(string[x]==caractcor[z][0]){//significa que o caracter já foi listado
                             x=x+5;//pula todos os cinco caracteres que estão (OU DEVERIAM ESTAR) junto com ele
                             break;
                        }
                        else{
                             if(caractcor[z][0]==0){//nenhum caractere cadastrado neste espaço
                                  caractcor[z][0]=string[x];//salva o caractere encontrado
                                  x++;
                                  caractcor[z][1]=string[x];//salva o caractere que segue (que é o que a pessoa quer que sebstitua o tal)
                                  x++;
                                  num[0]=string[x];//aqui para baixo ele vai pegar os tres proximos caracteres numericos (OBRIGATORIAMENTE NUMERICOS) que formam o valor da cor
                                  x++;
                                  num[1]=string[x];
                                  x++;
                                  num[2]=string[x];
                                  x++;
                                  caractcor[z][2]=atoi(num);
                                  //caractcor[z][2]=(num[0]-48)*100+(num[1]-48)*10+(num[2]-48);
                                  break;
                             }
                             else{
                                  z++;
                             }
                        }
                   }
                   break;
         }
    }
    while(fgets(string, MAXDIGDIRSISARQ, fluxo)){//lê uma linha do arquivo de cada vez, e escreve ela na matriz
         while(string[mx]!=0){
              if(string[mx]!=32) matrix[mx+1][my+1]=string[mx];//mais um, para deslocar todo o conteúdo, por que o gotoxy não trabalha com pontos "zero" e exclui o "32" que é o espaço
              string[mx]=0;//ja vai limpando a string no caminho
              mx++;
         }
         mx=0;
         my++;
    }
    switch(ord){
         case 0://escrita randomica dos caracteres
              srand(time(NULL));
              int matex[MAXLARGTELA][MAXALTTELA]={0};//matriz para organizar os  caracteres que ja foram escritos
              int c=0;//variavel que armazena a quantidade de caracteres que deve ser escrito
              int a=0, b=0;
              while(a<MAXLARGTELA){//função para contar os caracteres válidos (caracteres que serão realmente escritos)
                   while(b<MAXALTTELA){
                        if((matrix[a][b]!=0)and(a<yf and b<xf)){//encontrou um caracter válido
                             c++;
                        }
                        b++;
                   }
                   b=0;
                   a++;
              }
              int d=0;//variavel que armazena a quantidade de caracteres JA ESCRITOS
              a=b=0;
              while(1){
                   a=rand()%yf;
                   b=rand()%xf;
                   if(a>0 and b>0){
                        if((matrix[a][b]!=0)and(matex[a][b]==0)){
                             gotoxy(a+xi,b+yi);
                             x=0;// usado para caminhar entre as cores e caracteres ja salvos
                             while(x<255){//encontrar o caracter cadastrado (POR ISSO TODOS DEVEM SER LISTADOS NO INÍCIO DO ARQUIVO (NA PRIMEIRA LINHA))
                                  if(caractcor[x][0]==0) break;
                                  if(matrix[a][b]==caractcor[x][0]){
                                       textcolor(caractcor[x][2]);
                                       break;
                                  }
                                  x++;
                             }
                             printf("%1c", caractcor[x][1]);//printa o caracter configurado
                             matex[a][b]=1;
                             d++;
                        }
                   }//OBS: não contados valores MENORES que UM (1) por que o gotoxy não trabalha com zero
                   if(d>=c) return(0);//quando a quantidade de caracteres a serem escritos for igual a quantidade ja escrita, foi concluida a escrita da figura
              }
              break;
         //case 1:
              break;
         //default:
              printf("ERRO - Foi setada a variavel ord para um valor invalido (diferente de 0 ou 1)");
              getch();
              break;
    }
    return(0);
}
int main(void){
    tamanho_tela(200,200);
    grafike("Logo.txt", 0, 0, 200, 200);
    getch();
}
