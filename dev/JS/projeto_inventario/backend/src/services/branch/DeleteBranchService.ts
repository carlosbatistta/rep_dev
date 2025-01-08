import prismaClient from "../../prisma";

interface BranchRequest {
    id: string;
}

export class DeleteBranchService {
    async execute({ id }: BranchRequest) {
        const branch = await prismaClient.branch.delete({
            where: {
                id: id,
            },
        });

        return branch;
    }
}