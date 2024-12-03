function novoUsuario(info){
    let dados = {
        ...info,
        status: "ativo",
        inicio: "20/03/2023",
        codigo: 123
    }
}

novoUsuario({nome: "Jose", sobrenome: "Silva"})