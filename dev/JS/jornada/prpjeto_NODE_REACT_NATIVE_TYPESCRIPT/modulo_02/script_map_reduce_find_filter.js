let lista = ["Carlos", "José", "Maria"]

lista.map((item, index) => {
    console.log(`Passando: ${item} - Esta posição ${index}`)
})

let numeros = [5, 3, 2, 5]
let total = numeros.reduce((acumulador, numero, indice, original) => {
    console.log(`${acumulador} - total até o momento`);
    console.log(`${numero} - valor atual`);
    console.log(`${indice} - indice atual`);
    console.log(`${original} - array original`);

    return acumulador += numero;
})

console.log("TOTAL DO REDUCE: "+total);

let listagem = [5, 3, "Carlos", "José"];

let busca = listagem.find((item)=>{
    return item === "José";
})

let palavras = ["Matheus", "Ana", "José", "Ricardo Silva"];
let resultado = palavras.filter((item)=>{
    return item.length >=5;
})