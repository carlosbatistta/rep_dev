import prismaClient from "../../prisma";

interface InventRequest {
    tp_material: string;
    date_count: string;
    date_valid: string;
    origin: string;
    branch_code: string;
    storage_code: string;
}

export class CreateInventService {
    async execute({ tp_material, date_count, date_valid, origin, branch_code, storage_code }: InventRequest) {
        if (!tp_material && !document && !origin) {
            throw new Error("Todos os campos são obrigatórios");
        }

        const is_document = await prismaClient.number_control.findFirst({
            where: {
                branch_code: branch_code,
                storage_code: storage_code,
                service: 'document'
            }
        })

        const is_invent = await prismaClient.info_invent.findFirst({
            where: {
                branch_code: branch_code,
                storage_code: storage_code,
            }
        })

        if (is_invent) {
            throw new Error(`Inventário já cadastrado: ${is_invent.document} está Ativo.`);
        }

        const newInvent = await prismaClient.info_invent.create({
            data: {
                tp_material,
                document: is_document.number,
                date_count,
                date_valid,
                origin,
                branch_code,
                storage_code,
                access_nivel: 0,
            },
            select: {
                id: true,
                tp_material: true,
                document: true,
                date_count: true,
                date_valid: true,
                origin: true,
                branch_code: true,
                storage_code: true,
            },
        });

        console.log(newInvent)

        const info_stock = await prismaClient.info_stock.create({
            data: {
                branch_code: branch_code,
                storage_code: storage_code,
                date_count: date_count,
                document: is_document.number,
                access_nivel: 0,
            }
        })

        await prismaClient.number_control.update({
            where: {
                id: is_document.id
            },
            data: {
                number: is_document.number + 1
            }
        })

        console.log(info_stock)

        return { newInvent, info_stock };
    }
}