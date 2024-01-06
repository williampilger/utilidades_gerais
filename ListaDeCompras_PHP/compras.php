<?php
// Define o caminho completo do arquivo .txt
if( isset($_GET['lista']) )
{
    $lista = $_GET['lista'] ;
}
else
{
    header('Location: index.php');
}
$caminhoArquivo = __DIR__ ."/$lista";

// Verifica se o formulário foi enviado
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Obtém o valor do item enviado pelo formulário
    $item = $_POST['item'];


    // Abre o arquivo no modo de escrita
    $arquivo = fopen($caminhoArquivo, 'a');

    // Escreve o novo item no arquivo
    fwrite($arquivo, $item . PHP_EOL);

    // Fecha o arquivo
    fclose($arquivo);

    // Redireciona para a mesma página para evitar o reenvio do formulário
    header('Location: ' . $_SERVER['PHP_SELF']."?lista=$lista");
    exit;
}

// Verifica se um item deve ser removido da lista
if (isset($_GET['remove'])) {
    // Obtém o índice do item a ser removido
    $indice = $_GET['remove'];

    if($indice=='*'){
        rename($caminhoArquivo, str_replace('.txt','.trash', $caminhoArquivo));
        header('Location: index.php');
        exit;
    } else {

        // Lê o conteúdo do arquivo
        $conteudo = file_get_contents($caminhoArquivo);
    
        // Converte o conteúdo em um array
        $listaCompras = explode(PHP_EOL, $conteudo);
    
        // Remove o item correspondente ao índice
        if (isset($listaCompras[$indice])) {
            unset($listaCompras[$indice]);
        }
    
        // Reindexa o array
        $listaCompras = array_values($listaCompras);
    
        // Abre o arquivo no modo de escrita
        $arquivo = fopen($caminhoArquivo, 'w');
    
        // Escreve o novo conteúdo no arquivo
        fwrite($arquivo, implode(PHP_EOL, $listaCompras));
    
        // Fecha o arquivo
        fclose($arquivo);
    
        // Redireciona para a mesma página para evitar o reenvio do formulário
        header('Location: ' . $_SERVER['PHP_SELF']."?lista=$lista");
        exit;
    }
}

// Lê o conteúdo do arquivo
$conteudo = file_get_contents($caminhoArquivo);

// Converte o conteúdo em um array
$listaCompras = explode(PHP_EOL, $conteudo);
array_pop($listaCompras);

?>

<!DOCTYPE html>
<html>
<head>
    <title>Lista</title>
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

        form {
            margin-bottom: 20px;
            width: fit-content;
        }

        input[type="text"] {
            padding: 5px;
            font-size: 16px;
        }

        button {
            padding: 5px 10px;
            font-size: 16px;
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

        .delete-icon {
            margin-left: 10px;
            color: #ffff;
            cursor: pointer;
            background-color: #AA2222;
            padding: 5px 10px;
            border-radius: 5px;
            margin-right: 10px;
        }
        .delete-list {
            color: #ffff;
            cursor: pointer;
            background-color: #AA2222AA;
            padding: 5px 10px;
            border-radius: 5px;
            margin: 20px 10px;
            display: inline-block;
        }
    </style>
</head>
<body>
    <a href="index.php">&#8592; Voltar</a>
    <div class="titles-area">
        <h5>Lista:</h5>
        <h1><?=$lista?></h1>
    </div>
    <!-- Formulário para adicionar itens -->
    <form method="POST" action="">
        <input type="text" name="item" placeholder="Digite um item" required>
        <button type="submit">Adicionar</button>
    </form>

    <!-- Exibe a lista de compras -->
    <ul>
        <?php foreach ($listaCompras as $indice => $item) : ?>
            <li>
                <span class="delete-icon" onclick="removerItem(<?php echo $indice; ?>)">&#128465;</span>
                <span><?php echo $item; ?></span>
            </li>
        <?php endforeach; ?>
        <span class="delete-list" onclick="removerItem('*')">Excluir esta lista</span>
    </ul>

    <script>
        function removerItem(indice) {
            if ( indice!='*' || confirm('Tem certeza de que deseja remover este item?')) {
                window.location.href = '?lista=<?=$lista?>&remove=' + indice;
            }
        }
    </script>
</body>
</html>

