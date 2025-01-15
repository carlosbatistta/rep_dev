import prismaClient from "../../prisma";

export class DeleteProductService {
    async execute() {
        // Deleta todos os registros da tabela 'product'
        const deletedProducts = await prismaClient.product.deleteMany({});

        console.log("Dados apagados com sucesso.");

        return deletedProducts
    }
}