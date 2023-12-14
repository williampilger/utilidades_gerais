<?php

$listaArquivos = glob('*.txt');
$stringResumida = '';

?>

<!DOCTYPE html>
<html>
<head>
    <title>Lista de Compras</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        html, body {
            font-family: Arial, sans-serif;
            width: fit-content;
            margin: 0;
            padding: 10px;
        }

        a{
            text-decoration: none;
        }

        .titles-area{
            padding: 15px 0;
        }

        h1,h5 {
            color: #333;
            margin: 1px;
        }

        ul {
            list-style-type: none;
            padding: 0;
        }

        li {
            margin-bottom: 5px;
            display: flex;
            align-items: center;
        }

    </style>
</head>
<body>
    <a href="index.php">&#8592; Voltar</a>
    <div class="titles-area">
        <h1>Resumo das Listas</h1>
    </div>

    <!-- Exibe a lista de compras -->
    <div>
        <?
            foreach ($listaArquivos as $arquivo)
            {
                $conteudo = file_get_contents(__DIR__."/$arquivo");
                $listaCompras = explode(PHP_EOL, $conteudo);
                array_pop($listaCompras);
                if(count($listaCompras) > 0)
                {
                    $stringResumida .= str_replace('.txt','',$arquivo)."\r\n";
                    ?>
                        <div>
                            <span><?= str_replace('.txt','',$arquivo) ?></span>
                            <div>
                                <?php
                                    foreach ($listaCompras as $item)
                                    {
                                        $stringResumida .= "\t- $item\r\n";
                                        ?>
                                        <span>    - <?=$item?></span><br>
                                        <?
                                    }
                                ?>
                            </div>
                        </div><br>
                    <?
                }
            }
        ?>
        <button id="copy-btn">Copiar para área de transferência</button>
    </div>

    <script>
        document.getElementById('copy-btn').addEventListener( 'click', () => {
            var elementoTemporario = document.createElement("textarea");
            elementoTemporario.value = <?=json_encode($stringResumida)?>;
            document.body.appendChild(elementoTemporario);
            elementoTemporario.select();
            document.execCommand("copy");
            document.body.removeChild(elementoTemporario);

            alert("✅ Sucesso:\n\n A lista de compras foi copiada para sua área de transferência como texto simples.");
        })
    </script>
</body>
</html>

