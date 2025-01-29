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


        const newInvent = await prismaClient.invent.create({
            data: {
                tp_material,
                document: is_document.number,
                date_count,
                date_valid,
                origin,
                branch_code,
                storage_code,
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

        const info_stock = await prismaClient.info_stock.create({
            data: {
                branch_code: branch_code,
                storage_code: storage_code,
                document: is_document.number
            }
        })

        const info_invent = await prismaClient.info_invent.create({
            data:{
                branch_code: branch_code,
                storage_code: storage_code,
                document: is_document.number,
                date_count: date_count,
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

        return { newInvent, info_stock, info_invent };
    }
}