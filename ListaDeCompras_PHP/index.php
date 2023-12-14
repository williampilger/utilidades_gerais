<?php
// Verifica se o formulário foi enviado para criar uma nova lista
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Obtém o nome da nova lista enviado pelo formulário
    $nomeLista = $_POST['nome_lista'];

    // Cria um novo arquivo para a lista
    $nomeArquivo = "$nomeLista.txt";
    $caminhoArquivo = __DIR__ . "/$nomeArquivo";
    file_put_contents($caminhoArquivo, '');

    // Redireciona para a página da nova lista
    header('Location: compras.php?lista=' . urlencode($nomeArquivo));
    exit;
}

// Obtém a lista de arquivos de listas existentes
$listaArquivos = glob('*.txt');
?>

<!DOCTYPE html>
<html>
<head>
    <title>Listas de Compras</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body {
            font-family: Arial, sans-serif;
        }
        
        a{
            text-decoration: none;
            padding: 7px 14px;
            background-color:  #CCC;
            border-radius: 10px;
            margin: 4px;
            display: inline-block;
            font-size: 18px;
        }
        a.simp{
            background-color: #333;
            color: white;
            font-weight: bold;
        }

        h1 {
            color: #333;
        }

        form {
            margin-bottom: 20px;
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
        }
    </style>
</head>
<body>
    <h1>Listas de Compras</h1>

    <!-- Lista de listas existentes -->
    <?php if (empty($listaArquivos)) : ?>
        <p>Nenhuma lista encontrada.</p>
    <?php else : ?>
        <ul>
            <?php foreach ($listaArquivos as $arquivo) : ?>
                <?php
                    $nomeLista = pathinfo($arquivo, PATHINFO_FILENAME);
                    $linkLista = 'compras.php?lista=' . urlencode($arquivo);
                ?>
                <li><a href="<?php echo $linkLista; ?>"><?php echo $nomeLista; ?></a></li>
            <?php endforeach; ?>
            <li><a href="resume.php" class="simp">RESUMO</a></li>
        </ul>
    <?php endif; ?>

    <!-- Formulário para criar uma nova lista -->
    <form method="POST" action="">
        <input type="text" name="nome_lista" placeholder="Nome da Nova Lista" required>
        <button type="submit">Criar Lista</button>
    </form>
</body>
</html>