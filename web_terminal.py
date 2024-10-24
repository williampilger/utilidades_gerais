"""
 DANGEROUS: Terminal WEB
 
 Este script serve pra fins educativos ou testes. É altamente perigoso usar isso em produção!!

 O script abaixo pode ser executado diretamente, ou colocado na lista de coisas pra ser executada na inicialização.

 PS: É indispensável ter instalado já todo o flask.

 Você pode executar este script diretamente usando:
   Linux:
     bash -c "$(curl -fsSL https://raw.githubusercontent.com/williampilger/utilidades_gerais/refs/heads/master/web_terminal.py)"

 Faça o Download diretamente:
   Linux:
     curl -O https://raw.githubusercontent.com/williampilger/utilidades_gerais/refs/heads/master/web_terminal.py
   Windows:
     Invoke-WebRequest -Uri "https://raw.githubusercontent.com/williampilger/utilidades_gerais/refs/heads/master/web_terminal.py" -OutFile "web_terminal.py"

 Para executá-lo sem interface gráfica (oculto) no windows, basta alterar a extensão para `.pyw`
"""

from flask import Flask, render_template_string, request, jsonify
import subprocess

app = Flask(__name__)

html_template = """
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Terminal Web</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #282c34; color: #ffffff; padding: 20px; }
        #output { width: 100%; height: 300px; background-color: #1e1e1e; border: 1px solid #333; overflow-y: auto; padding: 10px; }
        #command { width: 100%; padding: 10px; border: none; }
        #send { padding: 10px; margin-top: 10px; }
    </style>
</head>
<body>
    <h1>Terminal Web</h1>
    <div id="output"></div>
    <input type="text" id="command" placeholder="Digite o comando aqui..."/>
    <button id="send">Enviar</button>

    <script>
        document.getElementById('send').addEventListener('click', function() {
            const command = document.getElementById('command').value;
            fetch('/execute', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ comando: command })
            })
            .then(response => response.json())
            .then(data => {
                const outputDiv = document.getElementById('output');
                if (data.erro) {
                    outputDiv.innerHTML += '<div style="color: red;">' + data.erro + '</div>';
                } else {
                    outputDiv.innerHTML += '<div>' + data.saida.replace(/\\n/g, '<br>') + '</div>';
                }
                outputDiv.scrollTop = outputDiv.scrollHeight;
            });
        });
    </script>
</body>
</html>
"""

@app.route('/')
def index():
    return render_template_string(html_template)

@app.route('/execute', methods=['POST'])
def execute_command():
    data = request.get_json()
    comando = data.get('comando')

    try:
        # Executa o comando e captura a saída
        resultado = subprocess.run(comando, shell=True, check=True, text=True, capture_output=True)
        return jsonify({'saida': resultado.stdout})
    except subprocess.CalledProcessError as e:
        return jsonify({'erro': e.stderr})

if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0', port=5000)
