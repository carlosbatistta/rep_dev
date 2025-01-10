import prismaClient from "../../prisma";

interface StorageRequest {
    id: string;
}

export class DeleteStorageService {
    async execute({ id }: StorageRequest) {
        const storage = await prismaClient.storage.delete({
            where: {
                id: id,
            },
        });

        return storage;
    }
}