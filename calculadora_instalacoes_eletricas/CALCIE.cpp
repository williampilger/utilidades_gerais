// DESENVOLVIMENTO: WILLIAM PILGER
// Funções:
//           Calculos até queda máxima de tensão, funcionando perfeitamente, para os métodos D e B1 de cobre, somente. (201702051129)
#include <stdio.h>
#include <stdlib.h>
#include <conio2.h>
#include <string.h>
#include <windows.h>
#include <time.h>
#include <math.h>//para raiz quadrada
//Constantes
#define MAXDIGDIRSISARQ 300//tamanho maximo de um diretório de arquivos do programa (arquivos internos) a ser pedido pelo programa.
#define MAXLARGTELA 200//maxima largura de tela
#define MAXALTTELA 200//maxima altura de tela
#define POSITEMPCHAR 200//maxima capacidade da char temporária (consequentemente, impossível que outros valores sejam maiores que ela!)
//cores
#define CORPADRAO 15 //cor padrão do menu NÂO CALECIONADO
#define CORMENU 240 //cor do menu celecionado
#define CORSIM 180 //cor do item que esta celecionado em algumas das colunas a ser preenchida
#define CORNAO 128 //cor do item que NAO esta celecionado em algumas das colunas do menu
#define CORERRO 192 //cor quando ocorre erro GRAVE (para o programa)
#define CORESP 3 //cor "especial" para marcar algumas partesinhas dos textos
//cores para a abertura
#define CDESENHOA 3
#define CDESENHOB 4
#define CDESENHOC 6
#define CDESENHOP 15
//declarando tabelas da norma
    float tabela36[16][5]={//seções nominais (COBRE/PVC) //B1-NCC:2 //B1-NCC:3 //D-NCC:2 //D-NCC:3
                      0.5,9,8,12,10,
                      0.75,11,10,15,12,
                      1,14,12,18,15,
                      1.5,17.5,15.5,22,18,
                      2.5,24,21,29,24,
                      4,32,28,38,31,
                      6,41,36,47,39,
                      10,57,50,63,52,
                      16,76,68,81,67,
                      25,101,89,104,86,
                      35,125,110,125,103,
                      50,151,134,148,122,
                      70,192,171,183,151,
                      95,232,207,216,179,
                      120,269,239,246,203,
                      150,309,275,278,230
                      };
    float tabela37[16][5]={//seções nominais (COBRE/XLPE) //B1-NCC:2 //B1-NCC:3 //D-NCC:2 //D-NCC:3
                      0.5,12,10,14,12,
                      0.75,15,13,18,15,
                      1,18,16,21,17,
                      1.5,23,20,26,22,
                      2.5,31,28,34,29,
                      4,42,37,44,37,
                      6,54,48,56,46,
                      10,75,66,73,61,
                      16,10,88,95,79,
                      25,133,117,121,101,
                      35,164,144,146,122,
                      50,198,175,173,144,
                      70,253,222,213,178,
                      95,306,269,252,211,
                      120,354,312,287,240,
                      150,407,358,324,271
    };
    float tabela40[30][3]={//TEMPERATURA AMBIENTE //Isolação de PVC //Isolação EPR ouXLPE
                           //IMPORTANTE: da posição 0 à 14, são em AMBIENTE; da posição 15 à XX é em SOLO
                         10,1.22,1.15,
                         15,1.17,1.12,
                         20,1.12,1.08,
                         25,1.06,1.04,
                         30,1,1,
                         35,0.94,0.96,
                         40,0.87,0.91,
                         45,0.79,0.87,
                         50,0.71,0.82,
                         55,0.61,0.76,
                         60,0.5,0.71,
                         65,0,0.65,
                         70,0,0.58,
                         75,0,0.5,
                         80,0,0.41,
                         10,1.1,1.07,//a partir daqui, NO SOLO
                         15,1.05,1.04,
                         20,1,1,
                         25,0.95,0.96,
                         30,0.89,0.93,
                         35,0.84,0.89,
                         40,0.77,0.85,
                         45,0.71,0.80,
                         50,0.63,0.76,
                         55,0.55,0.71,
                         60,0.45,0.65,
                         65,0,0.6,
                         70,0,0.53,
                         75,0,0.46,
                         80,0,0.83
                         };
    float tabela42[12][2]={//Numero de circuitos agrupados //FCA - Métodos A a F (APENAS)
                        1,1,
                        2,0.8,
                        3,0.7,
                        4,0.65,
                        5,0.6,
                        6,0.57,
                        7,0.54,
                        8,0.52,
                        9,0.5,
                        12,0.45,
                        16,0.41,
                        20,0.38
                        };
    float quedaunitaria[21][7]={//Seção nominal //Eletroduto Magn.-Circ. MONO-FP=0,8 //Eletroduto Magn.-Circ MONO-FP=0,95
                                //Eletroduto N Magn.-Circ MONO-FP=0,8 //Eletroduto N Magn.-Circ MONO-FP=0,95
                                //Eletroduto N Magn.-Circ TRI-FP=0,8 //Eletroduto N Magn.-Circ TRI-FP=0,95
                             1.5,23,27.4,23.3,27.6,20.2,23.9,
                             2.5,14,16.8,14.3,16.9,12.4,14.7,
                             4,9,10.5,8.96,10.6,1.79,9.15,
                             6,5.85,7,6.03,7.07,5.25,6.14,
                             10,3.54,4.2,3.63,4.23,3.17,3.67,
                             16,2.27,2.7,2.32,2.68,2.03,2.33,
                             25,1.5,1.72,1.51,1.71,1.33,1.49,
                             35,1.12,1.25,1.12,1.25,0.98,1.09,
                             50,0.86,0.95,0.98,0.94,0.76,0.82,
                             70,0.64,0.67,0.62,0.67,0.55,0.59,
                             95,0.5,0.51,0.48,0.5,0.43,0.44,
                             120,0.42,0.42,0.4,0.41,0.36,0.36,
                             150,0.37,0.35,0.35,0.34,0.31,0.3,
                             185,0.32,0.3,0.3,0.29,0.27,0.25,
                             240,0.29,0.25,0.26,0.24,0.23,0.21,
                             300,0.27,0.22,0.23,0.2,0.21,0.18,
                             400,0.24,0.2,0.21,0.17,0.19,0.15,
                             500,0.23,0.19,0.19,0.16,0.17,0.14,
                             630,0.22,0.17,0.17,0.13,0.16,0.12,
                             800,0.21,0.16,0.16,0.12,0.15,0.11,
                             1000,0.21,0.16,0.16,0.11,0.14,0.1
                             };
//declaração de estruturas
struct calculo{
               int metodo;//metodo de instalação. onde: 0=B1 1=D
               int rede;//rede, onde: 0=mono 1=tri
               int un;//tensão nominal
               int isolacao;//isolação do condutor, onde: 0=PVC 1=EPRouXLPE
               int condutor;//condutor, onde: 0=cobre
               int temperatura;//temperatura ambiente (ou do solo)
               int local;//instalado em: 0=ambiente 1=solo
               int eletroduto;//tipo de eletroduto, onde: 0=nãomagnetico 1=magnetico
               int ncc;//numero de condutores carregados
               int circuito;//tipo de curcuito, onde: 0=iluminação 1=potência
               float potencia;//potencia do circuito
               float fp;//fator de potência do circuito
               int agrupamento;//numero de condutores agrupados
               int comprimento;//distância da queda de tensão (em m(metros))
               float ib;//corrente de projeto
               float ilb;//corrente de projeto corrigida
               float iz;//corrente suportada
               float ilz;//corrente realmente suportada pelo condutor
               float secao;//armazena o valor atual de seção nominal
               float secaocapcond;//armazena seção definida pelo segundo método (máxima capacidade de condução de corrente elétrica)
               float circ;//armazena o valor maximo da queda de tensão (circuito de alimentação (1%) ou final(4%))
			   //float quedamax;//armazena a queda de tensão que houve sobre o condutor
               };
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
{//retorna ZERO se o arquivo a ser lido nao foi acessível ou nao continha nada, ou não foi possivel fazer...
    FILE *fluxo;
    if((fluxo=fopen(arquivo,"rt"))==NULL) {
		fluxo=fopen(arquivo,"wt");
		fprintf(fluxo,"77 66");
		fprintf(fluxo,"\n////////////////////////////////.///./././..........././..........././.../././././......./././././././////////////////////////////////////////////////////////////////");
		fprintf(fluxo,"\n/////////////////////////./././././././.../././.............................../.../...../././././././/////////////////////////////////////////////////////////////////");
		fprintf(fluxo,"\n//////////////////////////./././//././...../.............................................../././//////////////////////////////////////////////////////////////////////");
		fprintf(fluxo,"\n///////////////////////./././//././././././............................................./.../..././//././/////////////////////////////////////////////////////////////");
		fprintf(fluxo,"\n//////////////////////////././.../...................................................../..././././././././////////////////////////////////////////////////////////////");
		fprintf(fluxo,"\n/./////////////////././././..././.../...................................................../././...../././////.////////////////////////////////////////////////////////");
		fprintf(fluxo,"\n////////////////.///././././././.../............................................................././././././././//////////////////////////////////////////////////////");
		fprintf(fluxo,"\n/.///////////////./././././.../.../..............................................................././././/////////////////////////////////////////////////////////////");
		fprintf(fluxo,"\n//////////////////./././././......................................................................./././././//////////////////////////////////////////////////////////");
		fprintf(fluxo,"\n/./////////////./././././././........................................................................././././//.//////////////////////////////////////////////////////");
		fprintf(fluxo,"\n//////////////./././././.../...................................................................../....././././////////////////////////////////////////////////////////");
		fprintf(fluxo,"\n/.///////////././././././.../.................................................................../././.../././././/////////////////////////////////////////////////////");
		fprintf(fluxo,"\n////////////////././/../.../.........................................................................../././././//.///////////////////////////////////////////////////");
		fprintf(fluxo,"\n/./////////////./././././././......................................................................./....././////././/////////////////////////////////////////////////");
		fprintf(fluxo,"\n/.//////////////././.....//////...................................................................././...../././//.///////////////////////////////////////////////////");
		fprintf(fluxo,"\n/.///////...///./././...///...//.......././........................................................././...///.////////////////////////////////////////////////////////");
		fprintf(fluxo,"\n/////////    /////..././//.   ./.....///////////////.....///////////////.........../////............./.../..././././//////////////////////////////////////////////////");
		fprintf(fluxo,"\n/.///////.    .////././//     ./..../.              /.../.             ./........./.  .//..........././..././././././/////////////////////////////////////////////////");
		fprintf(fluxo,"\n/.///////.  .  .////.///   .  ./..../.              /../                ./......./.    .//..........././.../././//////////////////////////////////////////////////////");
		fprintf(fluxo,"\n/.///////.  //   //////   /.  ./..../.  ////////////.../   ///////////  ./....../.  /.  .//.............../././././///////////////////////////////////////////////////");
		fprintf(fluxo,"\n/.///////.  ///   ///.  .//.  ./..../.  ......../....../   //../...../////...../.  .//.  .//......./...../././////////////////////////////////////////////////////////");
		fprintf(fluxo,"\n/.///////.  ////.  ..  .///.  ./..../.         ./....../   //...        ./..../.  /////.  .//........./././././///////////////////////////////////////////////////////");
		fprintf(fluxo,"\n/.///////.  /////.    .////.  ./..../.  .///////......./   //../..../.  ./.../.            .//.........../././././////////////////////////////////////////////////////");
		fprintf(fluxo,"\n/.///////.  ///////  //././.  ./..../.  .///////////.../   //////////.  ./../.              .//..............././//././///////////////////////////////////////////////");
		fprintf(fluxo,"\n/.///////   ////.///////.//.  ./..../.              /../                ././.  .//////////.   //........./....././////.///////////////////////////////////////////////");
		fprintf(fluxo,"\n/.///////.  ///././//...../.  ./..../.              /.../..           ../...  .//.../././//.  ........../.../././././/////////////////////////////////////////////////");
		fprintf(fluxo,"\n/.////.///////././.../.....////......///////////////.....///////////////....///////////////////...............././////////////////////////////////////////////////////");
		fprintf(fluxo,"\n/./////./////././.../././.................../................................//.............///........././///////////////////////////////////////////////////////////");
		fprintf(fluxo,"\n/.//////././././............................................................/.               ./....../////////////////////////////////////////////////////////////////");
		fprintf(fluxo,"\n/./////.///./././././......................................................./   ...........   /.....//..          ...//////.... . .      .//  . ....... .  .//////////");
		fprintf(fluxo,"\n/.//////././.../...../.../.................................................//  .///////////. .//...//                ./////.             .//                //////////");
		fprintf(fluxo,"\n/./././//././././...../...................................................../   /./......./////....//   ///////////   /////.  .///////////////////.  /////////////////");
		fprintf(fluxo,"\n/.////././././..././......................................................../.               .//...//   ///////////   //.//.  .///////////////////.  /////////////////");
		fprintf(fluxo,"\n/./////./././././././.......................................................///............   //...//   ///..././//   /////.         /////////////   /////////////////");
		fprintf(fluxo,"\n/.////././././.../.../...../................................................/..////////////.  ./...//   ///////////   /////.   .    ./////////////   /////////////////");
		fprintf(fluxo,"\n/././//./////././.../././..././............................................/   ////////////.  ./...//   ///////////   /////.  .///////////////////   /////////////////");
		fprintf(fluxo,"\n/.//./././././....././.../.../............................................./.                 //...//                 //.//.  .///////////////////   /////////////////");
		fprintf(fluxo,"\n/./////././././.../.../......./............................................./.              ../...../.              .//////.  .///////////////////.  /////////////////");
		fprintf(fluxo,"\n/.////././././.../././..././................................................./////////////////.......///////////////////./////////////////////////////////////////////");
		fprintf(fluxo,"\n/././././././..././././././...../.............................................../...../././..........././//////////////././///////////////////////////////////////////");
		fprintf(fluxo,"\n/.//././././././././.../././..././......................................................................./.../././././//././//////////////////////////////////////////");
		fprintf(fluxo,"\n/././//./././..././././.../.../................................................................................././././///////////////////////////////////////////////");
		fprintf(fluxo,"\n/.//////././////././..././.../.../......................................................................./..././././//././////////////////////////////////////////////");
		fprintf(fluxo,"\n/.///////././././././././.../././..........................................................................././././//.////////////////////////////////////////////////");
		fprintf(fluxo,"\n/.//.///././////././././././././...../................................................................./././././//.///////////////////////////////////////////////////");
		fprintf(fluxo,"\n/.///././//././././././././//./././..................................................................././././////.////////////////////////////////////////////////////");
		fprintf(fluxo,"\n/.//////////././././././//.///./././.../././..................................................././...../././//////////////////////////////////////////////////////////");
		fprintf(fluxo,"\n/.///////////./////.///./////././././././..././...................................................../././/////////////////////////////////////////////////////////////");
		fprintf(fluxo,"\n/.////////////////././//././////././././.../././...../...................................../.../.../././././//////////////////////////////////////////////////////////");
		fprintf(fluxo,"\n/./////////////////////////////////./././././......./..././.../........................./././././././////.////////////////////////////////////////////////////////////");
		fprintf(fluxo,"\n/.//////////////////////////////////./////./././././././.../././......./........./....././././..././////./////////////////////////////////////////////////////////////");
		fprintf(fluxo,"\n/.///////////////////////////////////////////////./././././././././......././........././././././//.//////////////////////////////////////////////////////////////////");
		fprintf(fluxo,"\n/.//////////////////////////////////////////.///////./././././././././..././././..././././././////////////////////////////////////////////////////////////////////////");
		fprintf(fluxo,"\n/.///////////////////////////////////////////////////////./././//././././././././//././././//././/////////////////////////////////////////////////////////////////////");
		fprintf(fluxo,"\n//////////////////////////////////////////////////////////././//.///.///././././././././//////////////////////////////////////////////////////////////////////////////");
		fclose(fluxo);
		fluxo=fopen(arquivo, "rt");
	}
    //fluxo=fopen("Logo.txt","rt");
    char string[MAXLARGTELA]={0};
    char matrix[MAXLARGTELA][MAXALTTELA]={0};//matriz que armazena a imagem a ser exibida
    int cor[20][2]={0};//armazena as cores
    int mx=0, my=0;//localizam a matriz
    fgets(string, MAXDIGDIRSISARQ, fluxo);//pega a primeira linha do arquivo (que contém os parâmetros)
    int x=0,y=0, z=0;//variavel faz tudo
    char caract=0;//caractere a ser usado para criar a figura (se tiver em ZERO usa o caractere original)
    char num[3]={0};//armazena os numeros digitados para cores
    while(x<MAXLARGTELA){
         switch(string[x]){
              case 32://espaço (somente é ignorado)
                   x++;
                   break;
              case 111://letra 'o' (que significa usar caracteres especiais)
                   x++;//soma um, poir o PROXIMO caractere deverá ser o "caractere a ser usado"
                   caract=string[x];
                   if(string[x]!=32) x++;//caso o caractere escrito seja o "espaço", ele nao irá pular uma nova linha, pois poderá ser um caractere simples... ("Para dizer para o programa que queres usar espaços, não precisa escrever o espaço e dar mais um pára ceparar do prox comando")
                   break;
              default:
                   while((string[x]>=48 and string[x]<=57) and y<3){//se for um número (y<3 pq n tem cor que vai precisar de mais de tres caracteres)
                        cor[z][0]=cor[z][0]+(string[x]-48);
                        x++;
                   }
                   x++;
                   z++;
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
    srand(time(NULL));
    int matex[MAXLARGTELA][MAXALTTELA]={0};//matriz para organizar os  caracteres que ja foram escritos
    int c=0;//variavel que armazena a quantidade de caracteres que deve ser escrito
    int a=0, b=0;
    while(a<MAXLARGTELA){
         while(b<MAXALTTELA){
              if((a>0 and b>0)and(matrix[a][b]!=0)and(a<yf and b<xf)){//encontrou um caracter válido
                   c++;
                   x=0;
                   while(x<MAXLARGTELA){
                        if(cor[x][1]==matrix[a][b]){
                             break;
                        }
                        if(cor[x][1]==0){
                             cor[x][1]=matrix[a][b];//se chegou ate o ponto onde nao há mais caracteres ja encontrados, ele lista o novo
                             break;
                        }
                        x++;
                   }
              }
              b++;
         }
         b=0;
         a++;
    }
    int d=0;//variavel que armazena a quantidade de caracteres JA ESCRITOS
    a=b=0;
    //z=0;//o z é usado para armazenar novos caracteres na tabela de cores
    while(1){
         a=rand()%yf;
         b=rand()%xf;
         if(a>0 and b>0){
              if((matrix[a][b]!=0)and(matex[a][b]==0)){
                   gotoxy(a+xi,b+yi);
                   x=0;// usado para caminhar entre as cores e caracteres ja salvos
                   while(x<MAXLARGTELA){//se atingir o max de cores possiveis e nao encontrar desiste
                        if(cor[x][1]==0) break;
                        if(matrix[a][b]==cor[x][1]){
                             textcolor(cor[x][0]);
                             break;
                        }
                        x++;
                   }
                   if(caract==0) printf("%1c", matrix[a][b]);
                   else printf("%1c", caract);
                   matex[a][b]=1;
                   d++;
              }
         }//IBS: não contados valores MENORES que UM (1) por que o gotoxy não trabalha com zero
         if(d>=c) break;//quando a quantidade de caracteres a serem escritos for igual a quantidade ja escrita, foi concluida a escrita da figura
    }
}
float calcsecaominima(int circuito){//função para definir a seção mínima
     //recebe int circuito
     //       se 0 - Iluminação
     //       se 1 - Carga
     //       se 2 - Alimentador
     //Responde: Seção minima pela NBR5410/2004
     switch(circuito){
          case 0:
               textcolor(CORESP); printf("\n ####################################### Secao Minima #######################################");textcolor(CORPADRAO);
               printf("\n\n Conforme Tabela 47 da NBR5410/2004, a secao minima para circuitos de iluminacao e de 1,5 mm%c",253);//253 é o caracter de ao quadrado (²)
               return(1.5);
               break;
          case 1://esse não tem break pq tanto o 1 quanto o 2 servem para o mesmo
          case 2:
               printf("\n\n Conforme Tabela 47 da NBR5410/2004, a secao minima para circuitos de forca e de 2,5 mm%c",253);//253 é o caracter de ao quadrado (²)
               return(2.5);
               break;
          default:
               textcolor(CORERRO); printf("ERRO-001"); getch(); exit(0);
               break;
     }
}
float calcib(float potencia,int un, int rede, float fp){//função para calcular a corrente de projeto (Ib)
     float x;//variavel que armazena o ib
     textcolor(CORESP);printf("\n ################################# Corrente de projeto (Ib) #################################");textcolor(CORPADRAO);
     switch(rede){
          case 0://mono
               printf("\n      Sistema Monofasico");
               printf("\n Corrente de Projeto:");
               printf("\n     Ib = P / (Ul x FP)");
               printf("\n     Ib = %.2f / (%.2f x %.2f)", potencia, un, fp);
               x=potencia/(un*fp);
               printf("\n     Ib=%.2f", x);
               return(x);
               break;
          case 1://trifa
               printf("\n      Sistema Trifasico");
               printf("\n Corrente de Projeto:");
               printf("\n     Ib = P / (Ul x sqrt(3) x FP)");
               printf("\n     Ib = %.2f / (%.2f x sqrt(3) x %.2f)", potencia, un, fp);
               x=potencia/(un*sqrt(3)*fp);
               printf("\n     Ib=%.2f", x);
               return(x);
               break;
     }
     printf("\n\n Ib = S / Ul");
     printf("\n Ib = %.2f / %i", potencia, un);
     x=potencia/un;
     printf("\n Ib = %.2f A", x);
     return(x);
}
float calcilb(float ib,int temperatura,int local, int agrupamento, int isolacao){//função para calcular corrente de projeto corrigida (Ilb)
     int x, y;//o faz tudo de novo
     float fc;//fator de correção
     float ilb;//corrente de proj corrigida
     textcolor(CORESP);printf("\n ############################ Corrente de projeto Corrigida (I'b) ###########################");textcolor(CORPADRAO);
     x=0;
     printf("\n      Local de instalacao: ");
     if(local==0) printf("Ambiente");
     if(local==1) printf("Solo");
     printf("\n      Temperatura do ambiente: %i", temperatura);
     printf("\n      Numero de circuitos agrupados: %i", agrupamento);
     x=0;
     if(local==1) x=x+15;//pula para a parte do SOLO (na matriz com os valores da tabela)
     while(1){//encontrar a linha do fct
          if(temperatura<=tabela40[x][0]) break;//vai encontrar o primeiro valor maior ou igual à temperatura informada
          x++;
     }
     y=0;
     while(1){//encontrar fca
          if(agrupamento<=tabela42[y][0]) break;//encontra o agrupamento
          y++;
     }
     switch(isolacao){
          case 0://PVC
               printf("\n      Isolacao: PVC");
               printf("\n Fator de correcao por temperatura, segundo Tabela 40 da NBR5410/2004: \n     FCT = %.2f", tabela40[x][1]);
               printf("\n Fator de correcao por agrupamento, segundo Tabela 42 da NBR5410/2004: \n     FCA = %.2f", tabela42[y][1]);
               fc=tabela40[x][1]*tabela42[y][1];
               printf("\n Fator de correcao total: \n     FC = FCT x FCA\n     FC = %.2f x %.2f\n     FC = %.2f", tabela40[x][1], tabela42[y][1], fc);
               break;
          case 1://XLPE ou EPR
               printf("\n      Isolacao: EPR ou XLPE");
               printf("\n Fator de correcao por temperatura, segundo Tabela 40 da NBR5410/2004: \n FCT = %.2f", tabela40[x][2]);
               printf("\n Fator de correcao por agrupamento, segundo Tabela 42 da NBR5410/2004: \n FCA = %.2f", tabela42[y][1]);//SIM! é o mesmo fator de correção pela agrupamento
               fc=tabela40[x][2]*tabela42[y][1];
               printf("\n Fator de correcao total: \n     FC = FCT x FCA\n     FC = %.2f x %.2f\n     FC = %.2f", tabela40[x][2], tabela42[y][1], fc);
               break;
          default:
               textcolor(CORERRO); printf("ERRO-002"); getch(); exit(0);
               break;
     }
     printf("\n Corrente de projeto Corrigida:");
     printf("\n     I'b = Ib / FC");
     printf("\n     I'b = %.2f / %.2f", ib, fc);
     ilb=ib/fc;
     printf("\n     I'b = %.2f A", ilb);
     return(ilb);
}
float calcsecaocapcond(float ilb, int condutor, int isolacao, int metodo, int ncc){//função para definir a seção pela capacidade de condução
     int x;//o zé (faz tudo)
     int c;//aponta a linha
     textcolor(CORESP);printf("\n ######################### Secao pela maxima capacidade de conducao #########################");textcolor(CORPADRAO);
     switch(metodo){
          case 0://B1
               printf("\n      Método de instalacao B1");
               c=1;//2 ncc do B1 esta na coluna 1 da matriz
               break;
          case 1://D
               printf("\n      Método de instalacao D");
               c=3;//2 ncc do D esta na coluna 3 da matriz     -------    OBS: se o ncc for 3, ele soma um depois (logo abaixo)
               break;
          default:
               textcolor(CORERRO); printf("ERRO-004"); getch(); exit(0);
               break;
     }
     printf("\n      Numero de condutores carregados: %i", ncc);
     if(ncc==3) c++;//se o ncc for tres, em ambos os casos basta somar um, e a coluna da matriz estará certa
     printf("\n      Corrente de projeto corrigida: %.2f", ilb);
     x=0;
     switch(isolacao){
          case 0://PVC
               while(1){//encontra a seção na tabela 36
                        if(ilb<=tabela36[x][c]) break;
                        x++;
               }
               printf("\n Secao nominal conforme Tabela 36 da NBR5410/2004:\n     S = %.2f mm%c", tabela36[x][0], 253);
               printf("\n     Iz = %.2 Af", tabela36[x][c]);
               return(tabela36[x][0]);//o valor esta na coluna zero da matrix, e na linha x (encontrada)
               break;
          case 1://xple ou epr
               while(1){//encontra a seção na tabela 37
                        if(ilb<=tabela37[x][c]) break;
                        x++;
               }
               printf("\n Secao nominal conforme Tabela 37 da NBR5410/2004:\n     S = %.2f mm%c", tabela37[x][0], 253);
               printf("\n     Iz = %.2f A", tabela37[x][c]);
               return(tabela37[x][0]);//o valor esta na coluna zero da matrix, e na linha x (encontrada)
               break;
          default:
               textcolor(CORERRO); printf("ERRO-006"); getch(); exit(0);
               break;
     }
}
float calcqueda(float ib,float secao, int eletroduto, int rede, float fp, int comprimento, int un, int circ){//função para calcular a queda de tensão nos condutores
     //variaveis recebem valores conforme struct calculo
     //caso seja complicado de entender, pegue m mãos a Tabela 12 do manual trysmia, pag60. )Queda de tensão unitária(
     textcolor(CORESP);printf("\n ############################# Secao pela maxima queda de tensao ############################");textcolor(CORPADRAO);
     int c=1;//armazena COLUNA onde será procurado o valor
     float queda=0;
     if(fp>=0.875){
          printf("\n      FP = 0,95");
          c++;//se o fator de potência foi mais proximo de 0,95, soma uma coluna
     }
     else printf("\n      FP = 0,8");
     if(eletroduto==0){//se for eletroduto NAO MAGNETICO
          c=c+2; //mais duas colunas para a direita
          printf("\n      Eletroduto Nao Magnetico");
          if(rede==1){
               c=c+2;//se a rede for TRIFASICA, mais duas colunas para a direita
               printf("\n      Rede Trifasica");
          }
          else printf("\n      Rede Monofasica");
     }
     else printf("\n      Eletroduto Magnetico");
     printf("\n      Comprimento (L): %i m", comprimento);
     printf("\n      Conforme NR-10/2004, a queda maxima (Q) para circuitos ");
     if(circ==4){//circuito terminal
     	printf("terminais e de 4 porcento, logo:");
	 }
	 else printf("alimentadores e de 1 porcento, logo:");
	 printf("\n Queda unitaria (Qu):");
	 printf("\n    Qu = (Q x Un) / (Ib x L)");
	 printf("\n    Qu = ((%i / 100)  x %i) / (%.2f x (%i / 1000))",circ,un,ib,comprimento);
	 queda=(((float)circ/100)*(float)un)/(ib*((float)comprimento/1000));
	 printf("\n    Qu = %.2f", queda);
	 int x=0;
	 
     while(x<21){//encontra a linha da matriz onde está a seção do condutor usado no momento (tem 21 linhas na tabela)
          if(queda>=quedaunitaria[x][c]) break;
          x++;
     }
     printf("\n Segundo a Tabela 12 do manual Prysmian de Instalacoes Eletricas, para esta queda unitaria \nmaxima, a secao deve ser de, no minimo, %.2f mm%c", quedaunitaria[x][0],253);
	 if(secao<quedaunitaria[x][0]){
	 	  printf("\n Como esta secao supera a definida nos metodos anteriores, sera adotada a nova secao de %.2f mm%c", quedaunitaria[x][0], 253);
	 	  secao=quedaunitaria[x][0];//caso a minima pela queda seja maior que a atual, atualiza.
	 }
     return(secao);
}
int main(void){
    tamanho_tela(200,400);
    textcolor(CORESP);
    grafike("Logo.txt", 0, 0, 200, 200);
    textcolor(CORPADRAO);
    gotoxy(5,30); printf("Desenvolvimento William Pilger");
    gotoxy(80,45); printf("Projeto de calculadora automatica de condutores e protecoes");
    gotoxy(85,46); printf("Conforme: - NBR5410/2004 - Manual Prysmian - RIC BT v1.4");
    gotoxy(1,36); printf("Pressione ENTER para iniciar");
    unsigned char dig=0;//variavel que armazena o que foi digitado;
    int atua=1;// variavel que quando em 1, ordena que a tela seja completamente atualizada
    while(1){
         dig=getch();
         if(dig==13) break;
         if(dig==27) exit(0);
    }
    int opcao=1;
    char tempchar[POSITEMPCHAR]={0};
    int positempchar=0;
    int x;//AQUELE CARA QUE SERVE PARA QQR COISA, SEM CONTROLE. (USE SOMENTE NO LOCAL)
    struct calculo a;
    //definindo os mais "padrões" de costume
    a.agrupamento=1;
    a.circuito=0;
    a.comprimento=0;
    a.condutor=0;
    a.eletroduto=0;
    a.fp=1;
    a.isolacao=0;
    a.local=0;
    a.metodo=0;
    a.ncc=2;
    a.potencia=0;
    a.rede=0;
    a.un=220;
    a.temperatura=30;
    a.circ=4;
    //FIM definição "padrões"
    while(1){
         if(atua==1){//foi dada a ordem de atualizar completamente a tela
              textcolor(CORPADRAO); clrscr();
              gotoxy(1,1); textcolor(CORPADRAO);printf("Calculadora IE");
              gotoxy(1,3); if(opcao==1) textcolor(CORMENU); else textcolor(CORPADRAO); printf("Metodo de instalaca: "); if(a.metodo==0) textcolor(CORSIM); else textcolor(CORNAO); printf(" B1 "); if(a.metodo==1) textcolor(CORSIM); else textcolor(CORNAO); printf(" D ");
              gotoxy(1,4); if(opcao==2) textcolor(CORMENU); else textcolor(CORPADRAO); printf("Rede: "); if(a.rede==0) textcolor(CORSIM); else textcolor(CORNAO); printf(" Monifasica "); if(a.rede==1) textcolor(CORSIM); else textcolor(CORNAO); printf(" Trifasica ");
              gotoxy(1,5); if(opcao==3) textcolor(CORMENU); else textcolor(CORPADRAO); printf("Tensao Nominal: "); printf("%i", a.un);
              gotoxy(1,6); if(opcao==4) textcolor(CORMENU); else textcolor(CORPADRAO); printf("Isolacao: "); if(a.isolacao==0) textcolor(CORSIM); else textcolor(CORNAO); printf(" PVC "); if(a.isolacao==1) textcolor(CORSIM); else textcolor(CORNAO); printf(" EPR ou XLPE ");
              gotoxy(1,7); if(opcao==5) textcolor(CORMENU); else textcolor(CORPADRAO); printf("Condutor: "); if(a.condutor==0) textcolor(CORSIM); else textcolor(CORNAO); printf(" Cobre ");// if(a.condutor==1) textcolor(CORSIM); else textcolor(CORNAO); printf(" Aluminio ");
              gotoxy(1,8); if(opcao==6) textcolor(CORMENU); else textcolor(CORPADRAO); printf("Temperatura: "); printf("%i", a.temperatura);
              gotoxy(1,9); if(opcao==7) textcolor(CORMENU); else textcolor(CORPADRAO); printf("Instalado em: "); if(a.local==0) textcolor(CORSIM); else textcolor(CORNAO); printf(" Ambiente "); if(a.local==1) textcolor(CORSIM); else textcolor(CORNAO); printf(" Solo ");
              gotoxy(1,10); if(opcao==8) textcolor(CORMENU); else textcolor(CORPADRAO); printf("Eletroduto: "); if(a.eletroduto==0) textcolor(CORSIM); else textcolor(CORNAO); printf(" Nao Magnetico "); if(a.eletroduto==1) textcolor(CORSIM); else textcolor(CORNAO); printf(" Magnetico ");
              gotoxy(1,11); if(opcao==9) textcolor(CORMENU); else textcolor(CORPADRAO); printf("NCC: "); printf("%i", a.ncc);
              gotoxy(1,12); if(opcao==10) textcolor(CORMENU); else textcolor(CORPADRAO); printf("Circuito de: "); if(a.circuito==0) textcolor(CORSIM); else textcolor(CORNAO); printf(" Iluminacao "); if(a.circuito==1) textcolor(CORSIM); else textcolor(CORNAO); printf(" Forca ");
              gotoxy(1,13); if(opcao==11) textcolor(CORMENU); else textcolor(CORPADRAO); printf("Circuito: "); if(a.circ==4) textcolor(CORSIM); else textcolor(CORNAO); printf(" Final "); if(a.circ==1) textcolor(CORSIM); else textcolor(CORNAO); printf(" de Alimentação ");
			  gotoxy(1,14); if(opcao==12) textcolor(CORMENU); else textcolor(CORPADRAO); printf("Potencia: "); printf("%.2f", a.potencia);
              gotoxy(1,15); if(opcao==13) textcolor(CORMENU); else textcolor(CORPADRAO); printf("Fator de potencia: "); printf("%.2f", a.fp);
              gotoxy(1,16); if(opcao==14) textcolor(CORMENU); else textcolor(CORPADRAO); printf("Circuitos agrupados: "); printf("%i", a.agrupamento);
              gotoxy(1,17); if(opcao==15) textcolor(CORMENU); else textcolor(CORPADRAO); printf("Distancia da queda de tensao (m): "); printf("%i", a.comprimento);
              gotoxy(8,25); textcolor(CORPADRAO); printf("Preencha os campos. E pressione ENTER para iniciar o calculo...");
              atua=0;
         }
         if(kbhit()){//caso tenha cido pressionada uma tecla
              dig=getch();
              switch(dig){
                   case 224://teclas setas
                        dig=getch();
                        switch(dig){
                             case 72://para cima
                                  if(opcao>1) {opcao--; atua=1;}
                                  break;
                             case 80://para baixo
                                  if(opcao<15) {opcao++; atua=1;}
                                  break;
                             case 77://para a direita
                                  switch(opcao){
                                       case 1://metodo
                                            a.metodo=1;
                                            break;
                                       case 2://rede
                                            a.rede=1;
                                            a.ncc=3;
                                            break;
                                       case 3://Tensão nominal
                                            a.un++;
                                            break;
                                       case 4://isolação
                                            a.isolacao=1;
                                            break;
                                       case 6://temperatura
                                            a.temperatura++;
                                            break;
                                       case 7://ambiente ou solo
                                            a.local=1;
                                            break;
                                       case 8://eletroduto
                                            a.eletroduto=1;
                                            break;
                                       case 9://NCC
                                            a.ncc=3;
                                            break;
                                       case 10://circuito de potência
                                            a.circuito=1;
                                            break;
                                       case 12://potencia
                                            //a.potencia++;
                                            a.potencia=a.potencia+100;
                                            break;
                                       case 13://FP
                                            if(a.fp<1) a.fp=a.fp+0.01;
                                            break;
                                       case 11://circ
                                       		a.circ=1;
                                       		break;
                                       case 14://agrupamento
                                            a.agrupamento++;
                                            break;
                                       case 15://distância da queda de tensão
                                            a.comprimento++;
                                            break;
                                  }
                                  atua=1;
                                  break;
                             case 75://para a esquerda
                                  switch(opcao){
                                       case 1://metodo
                                            a.metodo=0;
                                            break;
                                       case 2://rede
                                            a.rede=0;
                                            a.ncc=2;
                                            break;
                                       case 3://Tensão nominal
                                            if(a.un>0) a.un--;
                                            break;
                                       case 4://isolação
                                            a.isolacao=0;
                                            break;
                                       case 6://temperatura
                                            a.temperatura--;
                                            break;
                                       case 7://ambiente ou solo
                                            a.local=0;
                                            break;
                                       case 8://eletroduto
                                            a.eletroduto=0;
                                            break;
                                       case 9://NCC
                                            a.ncc=2;
                                            break;
                                       case 10://circuito de potência
                                            a.circuito=0;
                                            break;
                                       case 12://potencia
                                            if(a.potencia>0) a.potencia--;
                                            break;
                                       case 13://FP
                                            if(a.fp>0) a.fp=a.fp-0.01;
                                            break;
                                       case 11://circ
                                       		a.circ=4;
                                       		break;
                                       case 14://agrupamento
                                            if(a.agrupamento>1) a.agrupamento--;
                                            break;
                                       case 15://distância da queda de tensão
                                            if(a.comprimento>0) a.comprimento--;
                                            break;
                                  }
                                  atua=1;
                                  break;
                        }
                        positempchar=0;//zera a posição da variavel que ordena a string temporária
                        break;
                   case 13: //CALCULAR (Enter pressionado)
                        clrscr();
                        a.secao=calcsecaominima(a.circuito);
                        printf("\n");
                        a.ib=calcib(a.potencia,a.un,a.rede,a.fp);
                        printf("\n");
                        a.ilb=calcilb(a.ib,a.temperatura,a.local, a.agrupamento, a.isolacao);
                        printf("\n");
                        a.secaocapcond=calcsecaocapcond(a.ilb, a.condutor, a.isolacao, a.metodo, a.ncc);
                        printf("\n");
                        if(a.secaocapcond>a.secao) a.secao=a.secaocapcond;
                        printf("\n");
                        a.secao=calcqueda(a.ib,a.secao,a.eletroduto,a.rede,a.fp, a.comprimento, a.un,a.circ);
                    	
                        //aqui entram as novas funçõessssss e a conclusão
                        getch();
                        atua=1;
                        break;
                   case 27://pessoa quis sair
                        exit(0);
                        break;
                   case 8://pessoa apaga texto
                        break;
                   default://pessoa digita texto
                        switch(opcao){
                             case 3://tensão nominal
                                  break;
                             case 6://temperatura
                                  break;
                             case 9://NCC
                                  break;
                             case 11://Potência
                                  break;
                             case 12://Fator de potência
                                  break;
                             case 14://Circuitos agrupados
                                  break;
                             case 15://Distância da queda de tensão
                                  break;
                        }
                        atua=1;
                        break;
              }
         }
    }
}
