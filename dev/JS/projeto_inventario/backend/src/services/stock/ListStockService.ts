import prismaClient from "../../prisma";

interface ListStockRequest {
    cost?: number
    storage_code?: string
    wms_control?: boolean
    total_quantity?: number
    reservation?: number
    unbalanced?: boolean
}

export class ListStockService {
    async execute(filters: ListStockRequest = {}) {
        const { cost, storage_code, wms_control, total_quantity, reservation, unbalanced } = filters;

        // Construir os filtros dinamicamente
        const whereClause: any = {}

        // Filtro por custo
        if (cost !== undefined) {
            whereClause.cost = {
                lte: cost, // Custo menor ou igual ao valor
            };
        }

        //Filtro por desbalanceamento
        if (unbalanced !== undefined) {
            whereClause.unbalanced = true
        }

        // Filtro por código de armazenamento
        if (storage_code !== undefined) {
            whereClause.storage_code = storage_code;
        }

        // Filtro por controle WMS
        if (wms_control === true) {
            whereClause.address_control = "1"; // Controle ativo
            whereClause.localiz_control = "S"; // Localização ativa

        } else if (wms_control === false) {

            whereClause.address_control = { not: "1" }
            whereClause.localiz_control = { not: "S" }
        }

        // Filtro por quantidade total
        if (total_quantity !== undefined) {
            whereClause.total_quantity = {
                gt: total_quantity, // Quantidade maior 
            };
        }

        // Filtro por reserva
        if (reservation !== undefined) {
            whereClause.reservation = {
                gt: reservation,
            };
        }

        // Depuração para verificar os filtros antes de aplicar
        console.log(wms_control)

        // Executar a consulta com filtros combinados
        const stock = await prismaClient.stock.findMany({
            where: whereClause,
        });

        return stock;
    }
}
