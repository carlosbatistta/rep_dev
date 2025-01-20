import prismaClient from "../../prisma";

interface InventRequest {
    tp_material: string;
    document: number;
    date_count: string;
    date_valid: string;
    origin: string;
    filial: string;
}

export class CreateInventService {
    async execute({ tp_material, document, date_count, date_valid, origin, filial }: InventRequest) {
        if (!tp_material && !document && !origin) {
            throw new Error("Todos os campos são obrigatórios");
        }


        const newInvent = await prismaClient.invent.create({
            data: {
                tp_material,
                document,
                date_count,
                date_valid,
                origin,
                filial,
            },
            select: {
                id: true,
                tp_material: true,
                document: true,
                date_count: true,
                date_valid: true,
                origin: true,
                filial: true
            },
        });

        return newInvent;
    }
}