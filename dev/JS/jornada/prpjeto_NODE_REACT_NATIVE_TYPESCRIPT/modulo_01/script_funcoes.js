var area = document.getElementById('area')
var areah3 = document.getElementById('areah3')

function entrar() {
    var nome = prompt("Digite seu nome");
    if (nome === '' || nome === null) {
        alert("Ops algo deu errado");
        area.innerHTML = "Clique no botão para entrar";
    } else {
        area.innerHTML = "Bem vindo! " + nome;
        let botaoMedia = document.createElement("button");
        botaoMedia.innerText = "Calcular Media";
        botaoMedia.onclick = media;
        area.appendChild(botaoMedia);
        let botaoSair = document.createElement("button");
        botaoSair.innerText = "Sair";
        botaoSair.onclick = sair;
        area.appendChild(botaoSair);
    }
}

function sair() {
    alert("Saiu!")
    area.innerHTML("Você saiu!")
}

function media(nota1, nota2) {
    var lista_notas = [];
    lista_notas[0] = prompt("Informe a 1ª nota: ");
    lista_notas[1] = prompt("Informe a 2ª nota: ");
    var media = (Number(lista_notas[0]) + Number(lista_notas[1])) / 2;
    if (media >= 7) {
        areah3.innerHTML = "Aluno aprovado com a média: " + media;
    } else {
        areah3.innerHTML = "Aluno reprovado com a média: " + media;
    }
}

