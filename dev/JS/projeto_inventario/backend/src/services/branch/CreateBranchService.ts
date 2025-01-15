import prismaClient from "../../prisma";

interface BranchRequest {
    name: string;
    code: string;
    status: boolean;
    address: boolean;
}

export class CreateBranchService {
    async execute({ name, code, status, address }: BranchRequest) {
        if (!name && !code) { 
            throw new Error("Name and code is required");
        }

        const newBranch = await prismaClient.branch.create({
            data: {
                name,
                code,
                status,
                address,
            },
            select: {
                id: true,
                name: true,
                code: true,
                status: true,
                address: true,
            },
        });

        return newBranch;
    }
}

