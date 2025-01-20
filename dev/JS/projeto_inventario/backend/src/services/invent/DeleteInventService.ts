import prismaClient from "../../prisma";

interface InventRequest {
    id: string
}

export class DeleteInventService {
    async execute({ id }: InventRequest) {
        const invent = await prismaClient.invent.delete({
            where: {
                id: id,
            },
        });

        return invent
    }
}