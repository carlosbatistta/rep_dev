import prismaClient from "../../prisma";

interface InventRequest {
    tp_material: string;
    document: number;
    date_count: string;
    date_valid: string;
    origin: string;
    branch_code: string;
}

export class CreateInventService {
    async execute({ tp_material, document, date_count, date_valid, origin, branch_code }: InventRequest) {
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
                branch_code,
            },
            select: {
                id: true,
                tp_material: true,
                document: true,
                date_count: true,
                date_valid: true,
                origin: true,
                branch_code: true
            },
        });

        return newInvent;
    }
}