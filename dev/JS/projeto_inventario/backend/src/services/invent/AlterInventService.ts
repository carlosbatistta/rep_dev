import prismaClient from "../../prisma";

interface InventRequest {
    document: number;
    filial: string;
    date_count: Date;
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
    async execute({ document, filial, date_count, accuracy_percent, accuracy_quanty, accuracy_value, total_inventory_quanty, total_inventory_value, total_stock_quanty, total_stock_value, difference_quanty, difference_value }: InventRequest) {
        if (!document && !filial) {
            throw new Error("Todos so campos são obrigatórios")
        }

        const invent = await prismaClient.invent.findFirst({
            where: {
                document: document,
                filial: filial,
                date_count: date_count
            }
        });

        await prismaClient.invent.update({
            where: {
                id: invent.id,
            },
            data: {
                accuracy_quanty,
                accuracy_value,
                accuracy_percent,
                total_stock_value,
                total_inventory_value,
                total_stock_quanty,
                total_inventory_quanty,
                difference_value,
                difference_quanty,
            },
            select: {
                accuracy_quanty: true,
                accuracy_value: true,
                accuracy_percent: true,
                total_stock_value: true,
                total_inventory_value: true,
                total_stock_quanty: true,
                total_inventory_quanty: true,
                difference_value: true,
                difference_quanty: true,
            }
        });

    }


}

