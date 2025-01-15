import prismaClient from "../../prisma";

interface VirtualLocationRequest {
    code: number;
    name: string;
}

export class AlterVirtualLocation {
    async execute({ code, name }: VirtualLocationRequest) {
        if (!name && !code) {
            throw new Error("Name and code is required");
        }

        const virtualLocation = await prismaClient.virtualLocation.create({
            data: {
                code,
                name,
                storage: {
                    connect: { id: "some-storage-id" } // replace with actual storage id or logic to get it
                }
            },
            select: {
                code: true,
                name: true,
            },
        });

        return virtualLocation;
    }
}