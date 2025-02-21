import prismaClient from "../../prisma";

export class DeleteMarketingClassService{
    async execute (){
        
        const delete_departament = await prismaClient.departament.deleteMany({})
        const delete_line = await prismaClient.line.deleteMany({})
        const delete_group = await 

        console.log("Dados apagados com sucesso.")


    }
}