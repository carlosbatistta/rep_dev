import prismaClient from "../../prisma";

interface CountRequest {
    count_quantity: number;
    difference: number;
    status: string;
    user_name: string;
    product_code: string;
    product_desc: string;
    storage_code: string;
    branch_code: string;
    address_code: string;
}

export class CreateCountService {
    async execute({ count_quantity, difference, status, user_name, product_code, product_desc, storage_code, branch_code, address_code }: CountRequest) {
        if (!count_quantity && !difference) {
            throw new Error("Count quantity and difference is required");
        }

        const newCount = await prismaClient.count.create({
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
                id: true,
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

        return newCount;
    }
}