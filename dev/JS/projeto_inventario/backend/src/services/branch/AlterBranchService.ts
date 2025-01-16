import prismaClient from "../../prisma";

interface BranchRequest {
    id: string;
    name: string;
    code: string;
    status: boolean;
    address: boolean;
}

export class AlterBranchService {
    async execute({ id, name, code, status, address }: BranchRequest) {
        if (!name && !code) { 
            throw new Error("Name and code is required");
        }

        const branch = await prismaClient.branch.update({
            where: {
                id: id,
            },
            data: {
                name,
                code,
                status,
                address,
            },
            select: {
                name: true,
                code: true,
                status: true,
                address: true,
            },
        });

        return branch;
    }
}