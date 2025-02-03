import prismaClient from "../../prisma";

interface CountRequest {
    count_quantity?: number;
    difference?: number;
    status?: string;
    user_name: string;
    product_code: string;
    product_desc: string;
    storage_code: string;
    branch_code: string;
    address_code: string;
}

export class AlterCountService {
    async execute({ count_quantity, difference, status, user_name, product_code, product_desc, storage_code, branch_code, address_code }: CountRequest) {
        if (!count_quantity && !difference && !status && !user_name && !product_code && !product_desc && !storage_code && !branch_code && !address_code) { 
            throw new Error("Todos os campos são obrigatórios");
        }

        const count_e = await prismaClient.count.findFirst({
            where: {
                product_code: product_code, 
                address_code: address_code,
                user_name: user_name,
            },
        });

        // Atualizar o count
        const count = await prismaClient.count.update({
            where: {
                id: count_e.id, // Replace with the actual unique id
            },
            data: {
                count_quantity,
                difference,
                status,
                user_name,
                product_code,
                product_desc,
                storage_code,
                branch_code,
                address_code,
            },
            select: {
                count_quantity: true,
                difference: true,
                status: true,
                user_name: true,
                product_code: true,
                product_desc: true,
                storage_code: true,
                branch_code: true,
                address_code: true,
            },
        });

        return count;
    }
}