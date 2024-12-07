// includes, startsWith, endsWith

let nomes = ["Matheus", "Lucas", "Jose"];
if (nomes.includes("Jose")) { //retorna true ou false, é casesensitive
    console.log("Está");
} else {
    console.log("Não está");
}

let nome = "Matheus"
console.log(nome.endsWith("eus"));
console.log(nome.startsWith("M"));