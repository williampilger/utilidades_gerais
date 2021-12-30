const crypto = require('crypto');

/**
 * Função para criptografar texto. (UTILIZA MÉTODO DE DESCONTINUADO)
 * @param {String} dataString String de conteúdo, codificado em UTF-8, obrigatoriamente.
 * @param {String} psw Senha da criptografia
 * @returns {String} Hexadecimal com conteúdo criptografado.
 */
function criptografa(dataString, psw){

    let cipher = crypto.createCipher('aes-256-ctr', psw);
    
    let crypted = cipher.update(dataString, 'utf-8', 'hex');

    console.log(crypted);

    return crypted;

}

/**
 * Função para descriptografar texto. (UTILIZA MÉTODO DE DESCONTINUADO)
 * @param {String} dataString String de conteúdo criptografado, codificado obrigatoriamente em HEXADECIMAL.
 * @param {String} psw Senha da criptografia
 * @returns {String} String com conteúdo descriptografado, codificado em UTF-8
 */
function descriptografa(dataString, psw){

    let decipher = crypto.createDecipher('aes-256-ctr', psw);

    let decrypted = decipher.update(dataString, 'hex', 'utf-8');

    console.log(decrypted);

    return decrypted;
}

// ###################################
//      EXEMPLO DE UTILIZAÇÃO:

let text = criptografa("teste123","0000");

console.log(text);

text = descriptografa(text, "0000");

console.log(text);
