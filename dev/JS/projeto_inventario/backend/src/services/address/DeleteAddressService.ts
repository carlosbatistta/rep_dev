import prismaClient from "../../prisma";

export class DeleteAddressService {
    async execute() {
        // Deleta todos os registros da tabela 'address'
        const deletedAddresses = await prismaClient.address.deleteMany({});

        console.log("Dados apagados com sucesso.");

        return deletedAddresses;
    }
}
