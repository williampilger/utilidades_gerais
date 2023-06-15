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
    header('Location: ' . $_SERVER['PHP_SELF']);
    exit;
}

// Verifica se um item deve ser removido da lista
if (isset($_GET['remove'])) {
    // Obtém o índice do item a ser removido
    $indice = $_GET['remove'];

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
    header('Location: ' . $_SERVER['PHP_SELF']);
    exit;
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
    <title>Lista de Compras</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            width: 100%;
        }

        a{
            text-decoration: none;
        }

        h1 {
            color: #333;
        }

        form {
            margin-bottom: 20px;
            width: 100%;
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
    </style>
</head>
<body>
    <a href="index.php">&#8592; Voltar</a>
    <h1>Lista de Compras: <?=$lista?></h1>
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
    </ul>

    <script>
        function removerItem(indice) {
            if (confirm('Tem certeza de que deseja remover este item?')) {
                window.location.href = '?remove=' + indice;
            }
        }
    </script>
</body>
</html>

