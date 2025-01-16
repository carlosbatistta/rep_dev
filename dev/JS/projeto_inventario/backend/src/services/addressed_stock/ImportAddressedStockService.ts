import { connectToSqlServer } from "../../database/sqlServer";
import prismaClient from "../../prisma";

interface AddressedStockRequest {
    branch_code: string;
}

export class ImportAddressedStockService {

    async execute({ branch_code }: AddressedStockRequest): Promise<any> {
        const branch = await prismaClient.branch.findFirst({
            where: {
                code: branch_code,
            },
        });

        try {

            // Conectar ao SQL Server
            const pool = await connectToSqlServer();

            // Query para buscar os dados da tabela no SQL Server
            const query = `
            select D14_QTDEST, D14_PRODUT, D14_LOCAL, D14_ENDER from [dbo].[D14010]
            where D14010.D_E_L_E_T_ <> '*'
            and D14_FILIAL = @branch_code
                `;

            // Executar a query no SQL Server
            const result = await pool.request().query(query);

            // Verificar se há dados retornados
            if (result.recordset.length === 0) {
                throw new Error("Não há dados.");
            }

            // Iterar pelos resultados e inserir no Prisma
            const importedData = result.recordset;
            for (const record of importedData) {
                const { D14_QTDEST, D14_PRODUT, D14_LOCAL, D14_ENDER } = record;

                const product = await prismaClient.product.findFirst({
                    where: {
                        code: D14_PRODUT,
                    },
                });

                if (!product) {
                    throw new Error(`Produto ${D14_PRODUT} não encontrado.`);
                }
                const storage = await prismaClient.storage.findFirst({
                    where: {
                        code: D14_LOCAL,
                    },
                });
                if (!storage) {
                    throw new Error(`Local ${D14_LOCAL} não encontrado.`);
                }

                //inserir no banco usando Prisma
                await prismaClient.addressed_stock.create({
                    data: {
                        addressed_quantity: D14_QTDEST,
                        branch_code: branch.code,
                        product_code: product.code,
                        storage_code: storage.code,
                        product_desc: product.description,
                        address_code: D14_ENDER, // Assuming D14_ENDER is the address code
                    },
                });
            }

            return { branch, importedData };

        } catch (error) {
            throw new Error(error.message);
        }
    }
}