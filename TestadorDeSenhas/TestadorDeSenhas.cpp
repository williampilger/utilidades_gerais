#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <conio2.h>
#include <windows.h>

#define CORPADRAO 15 //cor padrão do menu
#define CORCEL 240 //cor do menu celecionado
#define CORSIM 180
#define CORNAO 196

#define MAXDIG 100 //número máximo de digitos que a senha pode ter
#define MAXPARAM 100//número máximo de digitos dos parâmetros
#define MAXCAMINHO 200//número máximo de caracteres do caminho em que o print está salvo

int SimulaTecla(char tecla, int t){//tecla é a tecla 0-255, t é o tempo em ms que a tecla deve ficar pressionada
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

int main(void){
	int x,y,//auxiliares
		atuatela=1,//seta em 1 quando a tela deve ser atualizada
		opcao=0,//opcao do menu
		conf[10]={0};	//0-Tipo de senha (0:Decimal, 1:Exa, 2:Asci)
						//1-Considerar variação de tela (0: não, 1:sim)
						//2-Armazena o tamanho do delay
						//3-Tipo de comparação de tela (0:Fixa-> Usa arquivo referência, 1:Unica-> Compara com print único, tirado no início do ciclo, 2: Atualizada-> Compara com print anterior a cada siclo)
						//4-Sensibilidade da comparação de tela (0-100)
						//5-Tamanho do delay em MS
						//6-número de digitos da senha atual
						//7-número de digitos da linha de comando atual
	char senha[MAXDIG]={0},//armazena a senha calculada
		parametros[MAXPARAM]={0};//string que armazena parâmetros
	unsigned char dig=0; //armazena digito do teclado (pressionado, no momento da configuração)
	clrscr();//limpa tela
	conf[5]=50;//definindo tamanho do delay "padrão" (em ms)
	while(dig!=13){//menu de configuração
		if(atuatela==1){
			clrscr();
			textcolor(CORPADRAO);
			printf("\n\n                       Testador de senhas\n                     By: William Pilger\n\n\n");
			if(opcao==0)textcolor(CORCEL); else textcolor(CORPADRAO); printf("\nTipo de senha: ");
			if(conf[0]==0)textcolor(CORSIM); else textcolor(CORNAO); printf(" DECIMAL "); if(conf[0]==1)textcolor(CORSIM); else textcolor(CORNAO); printf(" EXADECIMAL "); if(conf[0]==2)textcolor(CORSIM); else textcolor(CORNAO); printf(" ASCII ");
			/*if(opcao==1)textcolor(CORCEL); else textcolor(CORPADRAO); printf("\nPartir de: (INDISPONIVEL)"); textcolor(CORPADRAO); printf(" %s", senha);
			if(opcao==2)textcolor(CORCEL); else textcolor(CORPADRAO); printf("\nConsiderar Variacao de tela: ");
			if(conf[1]==0)textcolor(CORSIM); else textcolor(CORNAO); printf(" NAO "); if(conf[1]==1)textcolor(CORSIM); else textcolor(CORNAO); printf(" SIM ");
			if(opcao==3)textcolor(CORCEL); else textcolor(CORPADRAO); printf("\nBase de comparacao da tela: ");
			if(conf[3]==0)textcolor(CORSIM); else textcolor(CORNAO); printf(" FIXA "); if(conf[3]==1)textcolor(CORSIM); else textcolor(CORNAO); printf(" UNICA "); if(conf[3]==2)textcolor(CORSIM); else textcolor(CORNAO); printf(" ATUALIZADA ");
			if(opcao==4)textcolor(CORCEL); else textcolor(CORPADRAO); printf("\nQuando detectada variacao de tela: ");
			if(conf[2]==0)textcolor(CORSIM); else textcolor(CORNAO); printf(" NADA "); if(conf[2]==1)textcolor(CORSIM); else textcolor(CORNAO); printf(" PARAR "); if(conf[2]==2)textcolor(CORSIM); else textcolor(CORNAO); printf(" REGISTRAR ");
			if(opcao==5)textcolor(CORCEL); else textcolor(CORPADRAO); printf("\nSensibilidade da variacao de tela (0-100): "); textcolor(CORPADRAO); printf("%d",conf[4]);*/
			if(opcao==6)textcolor(CORCEL); else textcolor(CORPADRAO); printf("\nLogica de operacao: "); textcolor(CORPADRAO); printf(" %s",parametros);
			if(opcao==7)textcolor(CORCEL); else textcolor(CORPADRAO); printf("\nTamanho do Delay (ms): "); textcolor(CORPADRAO); printf(" %d",conf[5]);
			textcolor(CORPADRAO);
			printf("\n\n Para confirmar, e dar inicio no ciclo de testes, pressione ENTER");
			if(opcao==3){
				switch(conf[3]){
					case 0:
						printf("\n\n\nComparacao FIXA: Usa UMA UNICA captura de tela, predefinida, para comparar com as telas atuais");
						break;
					case 1:
						printf("\n\n\nComparacao UNICA: Usa UMA UNICA captura de tela, tirada no inicio do ciclo, para comparar com as telas atuais");
						break;
					case 2:
						printf("\n\n\nComparacao ATUALIZADA: Usa capturas de tela tiradas a cada siclo para comparar com as telas atuais");
						break;
				}
			}
			if(opcao==6) printf("\n\n\nNesta opcao, deve ser configurada a sequencia de operacao.\nUse as LETRAS para:\n   D - Delay\n   X - Chutar chutar senha calculada\n   C - Comparar tela\n   E - Enviar Enter\n\nEm caso de necessidade especial, pode-se usar valores de TRES casas (EX: 255)\npara representar a tecla que deve ser enviada ao teclado.");
			if(opcao==7) printf("\n\n\nNeste campo deve ser preenchido o valor (inteiro) do tamanho do Delay (usado na funcao anterior)");
			
		}
		atuatela=0;//flag indica que tela foi atualizada;
		dig=getch();
		switch(dig){
			case 27://esc pressionada
				exit(1);
				break;
			case 13://enter pressionado
				break;
			case 8://apaga acracter
				switch(opcao){
					case 1: //a partir de (senha d qual a pessoa quer partir)
						break;
					case 6: //logica de operação
						if(conf[7]>0){
							conf[7]--;
							parametros[conf[7]]=0;
							atuatela=1;
						}
						break;
				}
				break;
			case 224://cetas de navegação pressionadas
				dig=getch();
				switch(dig){
					case 80: //para baixo
						if(opcao==0) opcao=6;//ATENÇÃO!!! PULANDO AS OPCÕES NÃO CONCLUÍDAS
						else if(opcao<7) opcao++;
						atuatela=1;
						break;
					case 72: //para cima
						if(opcao==6) opcao=0;//ATENÇÃO!!! PULANDO AS OPCÕES NÃO CONCLUÍDAS
						else if(opcao>0) opcao--;
						atuatela=1;
						break;
					case 77: //para direita
						switch(opcao){
							case 0://Tipo de senha (0-2)
								if(conf[0]<2){
									conf[0]++;
									atuatela=1;
								}
								break;
							case 2://Considera variação de tela?(0-1)
								conf[1]=1;
								atuatela=1;
								break;
							case 3://tipo de análise de tela(0-2)
								if(conf[3]<2){
									conf[3]++;
									atuatela=1;
								}
								break;
							case 4://quando detectada variação de tela, fazer? (0-3)
								if(conf[2]<2){
									conf[2]++;
									atuatela=1;
								}
								break;
							case 7://tamanho delay
								conf[5]+=50;
								atuatela=1;
								break;
						}
						break;
					case 75: //para esquerda
						switch(opcao){
							case 0://Tipo de senha (0-2)
								if(conf[0]>0){
									conf[0]--;
									atuatela=1;
								}
								break;
							case 2://Considera variação de tela?(0-1)
								conf[1]=0;
								atuatela=1;
								break;
							case 3://tipo de análise de tela(0-2)
								if(conf[3]>0){
									conf[3]--;
									atuatela=1;
								}
								break;
							case 4://quando detectada variação de tela, fazer? (0-3)
								if(conf[2]>0){
									conf[2]--;
									atuatela=1;
								}
								break;
							case 7:
								if(conf[5]>50)conf[5]-=50;
								atuatela=1;
								break;
						}
						break;
				}
				break;
			default://texto, npumero ou algo inválido
				switch(opcao){
					case 1://senha a partir de
						switch(conf[0]){//verifica tipo de senha
							case 0://DECIMAL
								break;
							case 1://EXADECIMAL
								
								break;
							case 2: //ASCII
								break;
						}
						break;
					case 6://parametros de operação
						if((dig==88||dig==69||dig==68||dig==67)||(47<dig&&dig<58)){//é letra válida ou número
							if(conf[7]<MAXPARAM){
								parametros[conf[7]]=dig;
								conf[7]++;
								atuatela=1;
							}
						}
						break;
				}
				break;
		}
	}
	//pessoa pressionou enter
	if(conf[1]==1&&conf[3]==0){//caso a pessoa tenha escolhido usar comparação de tela E marcou tela fixa
		clrscr();
		printf("\n\n\nInforme o Diretorio\Nome.extencao do arquivo de imagem que deve ser usado como base:");
		char caminhoprint[MAXCAMINHO];
		scanf("%s", &caminhoprint);
		FILE *fluxo;
		if((fluxo=fopen(caminhoprint, "rt"))==NULL){
			printf("\n\n       IMPOSSIVEL ABRIR ARQUIVO");
			exit(0);
		}
	}
	//FAZER ALGO QUE VERIFICA VALIDADE DA SENHA DIGITADA (OU RESTRINGIR, IMPEDINDO QUE SEJA INSERIDA UMA INVÁLIDA) #FALTA
	clrscr();
	printf("\n\nPRESSIONE ENTER NOVAMENTE PARA INICIAR O PROCESSO.\nAPOS VOCE TERA 10 SEGUNDOS PARA POSICINAR O CURSOR NO PONTO DA INSERCAO\n\n");
	Sleep(1000);
	system("pause");
	Sleep(10000);
	clrscr();
	x=0;
	unsigned char exacaract[16]={48,49,50,51,52,53,54,55,56,57,65,66,67,68,69,70};//caracteres exadecimais
	if(senha[0]==0) senha[0]=1;//desconsidera ZERO
	while(1){
		if(parametros[x]==0) x=0;
		switch(parametros[x]){
			case 'E'://enviar enter
				SimulaTecla(13,0);
				break;
			case 'X'://chuta senha
				switch(conf[0]){
					case 0://decimal
						break;
					case 1://exa
						y=0;
						while(1){//vai incrementando a senha
							if(senha[y]<15){
								senha[y]++;
								break;
							}
							else{
								senha[y]=1;
								y++;
							}
						}
						y=0;
						while(1){//enviar senha ao teclado
							if(senha[y]!=0){
								SimulaTecla(exacaract[senha[y]-1],0);
								y++;
							}
							else break;
						}
						break;
					case 2://ASCII
						break;
					default://erro
						break;
				}
				printf("\n");
				y=0;
				while(1){
					if(senha[y]!=0){
						printf("%c",exacaract[senha[y]-1]);
							y++;
					}
					else break;
				}
				break;
			case 'C'://comparar tela
				break;
			case 'D'://delay
				Sleep(conf[5]);
				break;
			default:
				break;
		}
		x++;
		if(kbhit()){//se tecla pressionada
			printf("\n\nProcesso pausado, apos pressionar qualquer tecla, aguardaremos 10s e continuaremos o processo\n\nOBS: ALGUMAS COMBINACOES SERAO PERDIDAS, PARA APROVEITAMENTO COMPLETO, REINICIE O PROCESSO\n\n");
			system("pause");
			Sleep(10000);
		}
	}
	exit(1);
}
