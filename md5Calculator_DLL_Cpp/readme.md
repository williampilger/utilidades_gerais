# Biblioteca DLL Exemplo

Esta biblioteca calcula o hash MD5 de uma string e a retorna.

Biblioteca exemplo: DLL escrita em C++, compilada com `g++`, e utilizada em solução C# no Visual Studio.

## Compilação

Para compilar a DLL é necessário instalar o MinGW, com a extenção G++. Siga as instruções [AQUI](https://github.com/williampilger/tutoriais/blob/master/windows/instalando_mingw.md).

A compilação pode ser feita simplesmente executando o `build.bat` contido neste repositório.

Para compilar um exemplo executável, que pode ser utilizado pelo terminal, utilize a primeira opção.

Para exportar a DLL, utilize a opção 2.

**Obs.**: Note que a exportação da biblioteca ocorrerá para o diretório 'out', de onde deverá ser copiada para utilização externa.

O MinGW, por padrão, compila em **32 bits**, então atente-se se configurar suas soluções e projetos para esta configuração. Para alterar isto é necessário adicionar explicitamente a plataforma que deseja utilizar, usando o **-m32** ou **-m64** na linha de comando.

Também é importante notar que no momento da compilação é preciso informar se deseja ou não compilar todas as dependências do projeto. Para isso basta adicionar **-static** na linha de comando. (No .bat que acompanha este exemplo isto já é feito).

## Utilizando a biblioteca DLL no Visual Studio

Aqui estou utilizando o **Visual Studio Professional 16.10.3** e as telas e observações podem mudar para versões futuras.

Atente-se à plataforma selecionada na solução, nos projetos e nas configurações de exportação dos projetos, pois incompatibilidades entre **x32** e **x64** são bastante comuns.

Além de alterar a plataforma destino na tela inicial do Visual Studio, é necessário abrir as configurações da solução, e alterar a plataforma de exportação. Também é necessário alterar, manualmente, a plataforma para cada um dos projetos da solução, faça isso indo até **Propriedades do projeto** -> **Compilar** -> **Destino da plataforma**. Lembrando que para utilizar bibliotecas de vínculo estático você **não pode usitizar 'AnyCPU'**.

Feito isto, vamos avançar para o código. Para importar a DLL utilizaremos o **[DllImport()]**, veja um exemplo:
```C#
using  System.Runtime.InteropServices;

namespace seuNameSpace
{
    public class Win32
    {
        [return: MarshalAsAttribute(UnmanagedType.U4)]
            [DllImport(@"..\dlls\md5.dll", CallingConvention = CallingConvention.Cdecl, EntryPoint = "md5Calc")]
                public static extern void md5(string str, StringBuilder hash);
    }
    public class suaClasse
    {
        public void seuMetodo(){
            string palavra = "orange";
            StringBuilder hash = new StringBuilder();
            Win32.md5(palavra, hash);// obtém o hash MD5 de 'orange'
            System.Console.WriteLine(hash); // Deve retornar 'b781cbb29054db12f88f08c6e161c199'
        }
    }
}
```

Lembrando que os nomes das classes e variaveis podem variar conforme sua preferência (inclusive a *Win32* usada no exemplo).

**Obs.**: Lembrando que é necessário que a biblioteca DLL esteja no diretório informado no momento do *DllImport*. No exemplo acima, coloquei a biblioteca no diretório relativo **@"..\dlls\md5.dll"**.


## Referências

Referência principal MD5: [zedwood.com](http://www.zedwood.com/article/cpp-md5-function)

Para compilar no linux, use:

> g++ main.cpp md5.cpp -o md5_sample && ./md5_sample

A saída deve ser:

> md5 of 'grape': b781cbb29054db12f88f08c6e161c199

