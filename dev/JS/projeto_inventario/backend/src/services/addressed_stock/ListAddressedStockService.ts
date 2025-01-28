import prismaClient from "../../prisma";

interface ListAddressedStockRequest {
    product_code?: number
    storage_code?: string
    reserve_quantity?: number
    transfer_quantity?: number
    address_code?: string
}

export class ListAddressedStockService {
    async execute(filters: ListAddressedStockRequest = {}) {
        const { product_code, storage_code, reserve_quantity, transfer_quantity, address_code } = filters;

        // Construir os filtros dinamicamente
        const whereClause: any = {};

        // Filtro por produto
        if (product_code !== undefined) {
            whereClause.product_code = product_code
        }

        // Filtro por código de armazenamento
        if (storage_code !== undefined) {
            whereClause.storage_code = storage_code;
        }

        // Filtro por quantidade reservada
        if (reserve_quantity !== undefined) {
            whereClause.reserve_quantity = {
                gt: reserve_quantity, // Quantidade maior ou igual ao valor
            };
        }

        // Filtro por quantidade de transferencia
        if (transfer_quantity !== undefined) {
            whereClause.transf_quantity = {
                gt: transfer_quantity,
            };
        }

        if(address_code !== undefined){
            whereClause.address_code = address_code;
        }

        // Depuração para verificar os filtros antes de aplicar
        console.log("Filtros aplicados:", JSON.stringify(whereClause, null, 2));

        // Executar a consulta com filtros combinados
        const stock = await prismaClient.addressed_stock.findMany({
            where: whereClause,
        });

        return stock;
    }
}