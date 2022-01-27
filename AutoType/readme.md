# AutoType Python

Ferramenta para auto-preencher dados com base em chaves pré cadastradas.

Aconselho utilizar a ferramenta com atalhos de teclado.

**IMPORTANTE**: Ferramenta desenvolvida de desenvolvedor para desenvolvedor. Não é bonito nem fácil de usar. Interface TEXTO apenas.

**IMPORTANTE 2**: Lamentavelmente não consegui fazer funcionar no linux, embora fosse o primeiro objetivo. O problema atualmente é uma travada que o sistema dá ao receber o `ALT+TAB` do pyautogui.

## Download

Para executar a aplicação, certifique-se de ter instalada a versão mais recente do Python. Que você pode obter no [Site oficial](python.org)

Você tem duas opções para executar esta aplicação. Usando o `Chamador Principal` você garante estar sempre rodando a versão mais recente, pois esta fará o download do codigo fonte e tudo que for necessário a cada vez que a aplicação é executada.
Ou usando o `Codigo fonte padrão`, que funcionará da mesma forma, porém sem dependência da internet e sem atualizações instantâneas.

Se optar por baixar todo o codigo, é necessário baixar todos os arquivos, menos o chamador.

- Baixe o conteúdo da pasta `src` e salve-o na pasta em que deseja utiliza-lo.

## Utilização

Na primeira execução (a menos que você crie ou copie um arquivo de configuração) não terão chaves cadastradas. Então basta que você mesmo as digite e presisone `enter` ou `tab` após digitar a chave para então cadastrar o conteúdo.

Lembre-se, automaticamente após terminar o cadastro ou escolher uma chave e pressionar enter, o conteúdo será preenchido onde seu cursor estiver posicionado.

Após cadastrar algumas chaves você poderá pesquisar pelas chaves sempre que abrir o script. e usar a `Setas do mouse` para navegar entre as opções disponíveis.

## Criando o atalho de teclado, no Windows

- Salve o seu script (completo ou o chamador) em um local qualquer;
- clique sobre ele com o botão direito do mouse e selecione **enviar para** -> **area de trabalho (criar atalho)**;
- Clique com o botão direito sobre o atalho criado, e selecione **propriedades**;
- clique no campo **teclas de atalho**, e pressione a combinação de teclas que deseja cadastrar.
