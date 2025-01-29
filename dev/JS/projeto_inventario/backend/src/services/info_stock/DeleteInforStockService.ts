import prismaClient from "../../prisma";

interface InfoStockRequest {
    branch_code: string;
    document: number;
}

export class DeleteInfoStockService {
    async execute({ branch_code, document }: InfoStockRequest) {
        const deletedImfoStock = await prismaClient.info_stock.findFirst({
            where: {
                branch_code: branch_code,
                document: document
            }
        })
        await prismaClient.info_stock.delete({
            where: {
                id: deletedImfoStock.id
            }
        });
        console.log("Dados apagados com sucesso.");
        return { deletedImfoStock };
    }
}