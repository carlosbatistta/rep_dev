import { connectToSqlServer } from "../../database/sqlServer";
import prismaClient from "../../prisma";

interface StockRequest {
    branch_code: string;
}

export class ImportStockService {

    async execute({ branch_code }: StockRequest): Promise<any> {

        try {

            // Conectar ao SQL Server
            const pool = await connectToSqlServer();

            // Query para buscar os dados da tabela no SQL Server
            const query_geral = `
                select B2_QATU, B2_COD, B2_LOCAL, B2_FILIAL from [dbo].[SB2010]
                where SB2010.D_E_L_E_T_ <> '*'
                and B2_FILIAL = @branch_code
                `;

            // Executar a query no SQL Server
            const result_geral = await pool.request()
                .input("branch_code", branch_code) // Insere o valor de `branch_code`
                .query(query_geral);

            const query_cost = `
                SELECT BZ_COD, BZ_LOCPAD, BZ_CUSTD FROM [dbo].[SBZ010]
                WHERE SBZ010.D_E_L_E_T_ <> '*'
				AND BZ_FILIAL = @branch_code
            `
            const result_cost = await pool.request()
                .input("branch_code", branch_code) // Insere o valor de `branch_code`
                .query(query_cost);

            // Verificar se há dados retornados
            if (result_geral.recordset.length === 0) {
                throw new Error("Não há dados na B2.");
            }

            if (result_cost.recordset.length === 0) {
                throw new Error("Não há dados na BZ")
            }

            // Iterar pelos resultados e inserir no Prisma
            const imported_data = result_geral.recordset;
            const imported_data_cost = result_cost.recordset;
            for (const record of imported_data) {
                const { B2_QATU, B2_COD, B2_LOCAL, B2_FILIAL } = record;

                const product = await prismaClient.product.findFirst({
                    where: {
                        code: B2_COD,
                    },
                });

                if (!product) {
                    throw new Error(`Produto ${B2_COD} não encontrado.`);
                }

                //inserir no banco usando Prisma
                await prismaClient.stock.create({
                    data: {
                        total_quantity: B2_QATU,
                        branch_code: B2_FILIAL.trim(),
                        product_code: product.code,
                        storage_code: B2_LOCAL.trim(),
                        product_desc: product.description,
                        cost: 0
                    },
                });

            }

            for (const record of imported_data_cost) {
                const { BZ_COD, BZ_LOCPAD, BZ_CUSTD } = record;

                const stock = await prismaClient.stock.findFirst({
                    where: {
                        product_code: BZ_COD.toString().trim(),
                        storage_code: BZ_LOCPAD.toString().trim()
                    },
                });
                if (stock) {
                    await prismaClient.stock.update({
                        where: {
                            id: stock.id,
                        },
                        data: {
                            cost: BZ_CUSTD
                        }
                    })
                }
            }
            console.log("Dados importados com sucesso.");
            return imported_data; // Retornar os dados importados, se necessário
        } catch (error) {
            console.error("Erro ao importar dados do SQL Server:", error);
            throw new Error("Failed to import data from SQL Server.");
        }
    }
}
