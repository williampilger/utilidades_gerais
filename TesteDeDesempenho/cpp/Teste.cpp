#include <stdio.h>
#include <windows.h>
//#include <math.h>

void teste_matematica_avancada(void){
	int x = 54, n = 500;
	printf("\n\n\nIniciando Teste de MATEMATICA AVANCADA, em C++");
	
	int tempo;
	tempo = clock();
	int i, j, k, z=0;
	double float var1 = 9871528;
	double float var2 = 52525;
	double float var3 = 9871527;
	double float var4 = 52523;
	double float traa;
	for(i=0;i<n;i++){
	    for(j=0;j<n;j++){
	        for(k=0;k<n;k++){
	            traa = pow(sqrt(pow(x,100)), 1/100)+var1*var2-var3*var4;
	            z ++;
	        }
	    }
	}
	tempo = clock() - tempo;
	printf("\n %d Repeticoes\n Em %d ms", z, tempo);
}

void teste_divisao_multiplicacao(void){
	int x, y, n = 500;
	printf("\n\n\nIniciando Teste de DIVISAO E MULTIPLICACAO, em C++");
	int tempo;
	tempo = clock();
	x = n;
	int i, j, k, z=0;
	for(i=0;i<n;i++){
	    for(j=0;j<n;j++){
	        for(k=0;k<n;k++){
	            y = x;
	            x *= x;
	            x = x / y;
	            z ++;
	        }
	    }
	}
	tempo = clock() - tempo;
	printf("\n %d Repeticoes\n Em %d ms", z, tempo);
}

void teste_comparacao_strings(void){
	int x, y, n = 500;
	printf("\n\n\nIniciando Teste de COMPARACAO DE STRINGS, em C++");
	int tempo;
	tempo = clock();
	char teste1[37] = "este é um exemplo de string simples";
	char teste2[39] = "esta é uma forma de testar as strings";
	char teste3[4] = "esta";
	char teste4[6] = "string";
	int i, j, k, z=0;
	for(i=0;i<n;i++){
	    for(j=0;j<n;j++){
	        for(k=0;k<n;k++){
	            strcmp(teste1, teste2);
	            strcmp(teste2, teste3);
	            strcmp(teste3, teste4);
	            strcmp(teste4, teste1);
	            z++;
	        }
	    }
	}
	tempo = clock() - tempo;
	printf("\n %d Repeticoes\n Em %d ms", z, tempo);
}

int main(void){
	int tempo = clock();
	teste_divisao_multiplicacao();
	teste_matematica_avancada();
	teste_comparacao_strings();
	printf("\n\nFIM DO TESTE.\nTempo total de execucao: %d ms\n\n", clock()-tempo);	
}

