import prismaClient from "../../prisma";

interface VirtualLocationRequest {
    id: string;
    code: number;
    name: string;
}

export class CreateVirtualLocationService {
    async execute({ code, name }: VirtualLocationRequest) {
        if (!name || !code) {
            throw new Error("Código e nome são obrigatórios");
        }

        const virtualLocation = await prismaClient.virtualLocation.create({
            data: {
                code,
                name,
                storage: {
                    connect: {
                        id: "some-storage-id" // replace with actual storage id
                    }
                },
            },
            select: {
                id: true,
                code: true,
                name: true,
            },
        });

        return virtualLocation;
    }
}