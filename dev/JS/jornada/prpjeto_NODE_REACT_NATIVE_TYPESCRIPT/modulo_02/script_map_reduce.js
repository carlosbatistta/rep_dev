let lista = ["Carlos", "José", "Maria"]

lista.map((item, index) => {
    console.log(`Passando: ${item} - Esta posição ${index}`)
})

let numeros = [5, 3, 2, 5]
let total = numeros.reduce((acumulador, numero, indice, original) => {
    console.log(`${acumulador} - total até o momento`);
    console.log(`${numero} - valor atual`);
    console.log(`${acumulador} - total até o momento`);
})