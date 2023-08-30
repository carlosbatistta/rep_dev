const produto1 = {
    nome: "Casaco Branco",
    preco: 70.45,
    imagem: "product-1.jpg",
    info: "Produto Casaco"
}

const cartao_produto =
    `<div id = "card-produto-1" >
        <img src="./assets/img/${produto1.imagem}" alt=${produto1.info} style="height: 150px"/>
        <p>${produto1.nome}</p>
        <p>${produto1.preco}</p>
        <button>Adicionar ao carrinho</button>
      </div >`
document.getElementById("container-produto").innerHTML += cartao_produto;
