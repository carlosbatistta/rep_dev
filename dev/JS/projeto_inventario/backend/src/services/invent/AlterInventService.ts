import prismaClient from "../../prisma";

interface InventRequest {
    document: number;
    filial: string;
    date_count: string;
    accuracy_quanty: number,
    accuracy_value: number,
    accuracy_percent: number,
    total_stock_value: number,
    total_inventory_value: number,
    total_stock_quanty: number,
    total_inventory_quanty: number,
    difference_value: number,
    difference_quanty: number
}

export class AlterInventService {
    async execute({ document, filial, date_count, difference_quanty, difference_value }: InventRequest) {
        if (!document && !filial) {
            throw new Error("Todos so campos são obrigatórios")
        }

        const invent = await prismaClient.info_invent.findFirst({
            where: {
                document: document,
                branch_code: filial,
                date_count: date_count
            }
        });

    }


}

