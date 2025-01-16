import { connectToSqlServer } from "../../database/sqlServer";
import prismaClient from "../../prisma";

interface StockRequest {
    branch_code: string;
}

export class ImportStockService {

    async execute({ branch_code }: StockRequest): Promise<any> {
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
                select B2_QATU, B2_COD, B2_LOCAL, B2_FILIAL from [dbo].[SB2010]
                where SB2010.D_E_L_E_T_ <> '*'
                and B2_FILIAL = @branch_code
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
                const { B2_QATU, B2_COD, B2_LOCAL, B2_FILIAL } = record;

                const product = await prismaClient.product.findFirst({
                    where: {
                        code: B2_COD,
                    },
                });

                if (!product) {
                    throw new Error(`Produto ${B2_COD} não encontrado.`);
                }
                const storage = await prismaClient.storage.findFirst({
                    where: {
                        code: B2_LOCAL,
                    },
                });
                if (!storage) {
                    throw new Error(`Local ${B2_LOCAL} não encontrado.`);
                }

                //inserir no banco usando Prisma
                await prismaClient.stock.create({
                    data: {
                        total_quantity: B2_QATU,
                        branch_code: branch.code,
                        product_code: product.code,
                        storage_code: storage.code,
                        product_desc: product.description,
                        product: { connect: { id: product.id } },
                        storage: { connect: { id: B2_LOCAL } },
                        branch: { connect: { id: branch.code } },
                    },
                });

            }
            console.log("Dados importados com sucesso.");
            return importedData; // Retornar os dados importados, se necessário
        } catch (error) {
            console.error("Erro ao importar dados do SQL Server:", error);
            throw new Error("Failed to import data from SQL Server.");
        }
    }
}
