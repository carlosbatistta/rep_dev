import prismaClient from "../../prisma";

interface CountRequest {
    status: string;
    document: number;
    user_name: string;
    product_code: string;
    product_desc: string;
    storage_code: string;
    branch_code: string;
    address_code?: string;
    date_count: string;
}

export class CreateCountService {
    async execute({ document, date_count, status, user_name, product_code, product_desc, storage_code, branch_code, address_code }: CountRequest) {
        const branch = await prismaClient.branch.findFirst({
            where: {
                code: branch_code,
            },
        });

        let newCount;
        if (branch.address === true) {

            const count = await prismaClient.count.findFirst({
                where: {
                    product_code: product_code,
                    address_code: address_code,
                    date_count: date_count,
                    document: document,
                    branch_code: branch_code,
                    storage_code: storage_code,
                },
            })

            if (count.status === 'Recontagem' || count.status === 'Contado') {
                newCount = await prismaClient.count.create({
                    data: {
                        count_quantity: 0, // or any default value
                        status,
                        user_name,
                        product_code,
                        product_desc,
                        storage_code,
                        branch_code,
                        address_code,
                        date_count,
                        document,
                    },
                    select: {
                        id: true,
                        count_quantity: true,
                        status: true,
                        user_name: true,
                        product_code: true,
                        product_desc: true,
                        storage_code: true,
                        branch_code: true,
                        address_code: true,
                    },
                });
            }

        } else if (branch.address === false) {

            const count = await prismaClient.count.findFirst({
                where: {
                    product_code: product_code,
                    address_code: address_code,
                    date_count: date_count,
                    document: document,
                    branch_code: branch_code,
                    storage_code: storage_code,
                },
            })
            if (count.status === 'Não iniciado' ) {
            newCount = await prismaClient.count.create({
                data: {
                    document,
                    date_count,
                    count_quantity: 0, // or any default value
                    status,
                    user_name,
                    product_code,
                    product_desc,
                    storage_code,
                    branch_code,
                },
                select: {
                    id: true,
                    document: true,
                    count_quantity: true,
                    date_count: true,
                    status: true,
                    user_name: true,
                    product_code: true,
                    product_desc: true,
                    storage_code: true,
                    branch_code: true,
                },
            });
        }
    }
        return newCount;
    }
}