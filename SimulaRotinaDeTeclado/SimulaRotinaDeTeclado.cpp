#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <conio2.h>
#include <windows.h>
//CONSTANTES
#define DELAY_ENTRE_CARACTERES 100 //delay dado depois de cada inserção
#define LOG 1
int SimulaTecla(unsigned char tecla, int t){//tecla é a tecla 0-255, t é o tempo em ms que a tecla deve ficar pressionada
	INPUT ip;
	//Copiado, Não sei exatamente o significado
	ip.type=INPUT_KEYBOARD;
	ip.ki.wScan=0;
	ip.ki.time=0;
	ip.ki.dwExtraInfo=0;
	//Pressionando Tecla
	ip.ki.wVk=tecla;//Grava valor da tecla na estrutura
	ip.ki.dwFlags=0;//Setada em zero significa tecla pressionada
	SendInput(1,&ip,sizeof(INPUT));//nesse momento envia o pacote de dados para o sistema, que falva no buffer do teclado
	Sleep(t);
	//Soltanto Tecla
	//ip.ki.dwFlags=KEYEVENTF_KEYUP;//esta constante contém o valor padrão para o comando de tecla solta
	//(1,&ip,sizeof(INPUT));//nesse momento envia o pacote de dados para o sistema, que falva no buffer do teclado
	return(1);
}
int main (void){
	if(!LOG) FreeConsole(); //oculta o console
	FILE *fluxo;
	unsigned char dig=0, di;
	
	while(dig<255){
		printf("\n%c ", dig);
		SimulaTecla(dig,DELAY_ENTRE_CARACTERES);
		di=getch();
		printf("%c", di);
		dig++;
	}
	
	if((fluxo=fopen("regra.txt", "rt"))==NULL){
		exit(1);
	}
	while(!feof(fluxo)){
		dig=getc(fluxo);
		switch(dig){
			case '\n':
				dig = 13; //substitui digito por enter
			default:
				if (LOG) printf("%c", dig);
				SimulaTecla(dig,DELAY_ENTRE_CARACTERES);
		}
	}
	exit(0);
}
