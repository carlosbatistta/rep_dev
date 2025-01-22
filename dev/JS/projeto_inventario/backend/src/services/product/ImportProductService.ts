import { connectToSqlServer } from "../../database/sqlServer";
import prismaClient from "../../prisma";

interface ProductRequest {
    branch_code: string;
}

export class ImportProductService {
    async execute({ branch_code }: ProductRequest): Promise<any> {
        try {
            // Conectar ao SQL Server
            const pool = await connectToSqlServer();

            // Query para buscar os dados da tabela no SQL Server
            const query_geral = `
                SELECT DISTINCT B1_DESC, B1_COD, B1_CODBAR, B1_TIPO, B1_ESPECIF FROM [dbo].[SB1010]
                WHERE SB1010.D_E_L_E_T_ <> '*'
                AND B1_TIPO = 'ME'
                AND B1_CODBAR != ''
            `;

            const result_geral = await pool.request().query(query_geral);

            const query_cost = `
                SELECT DISTINCT BZ_COD, BZ_CUSTD, BZ_FILIAL, BZ_LOCPAD
                FROM SBZ010
                WHERE BZ_FILIAL = @branch_code
                AND SBZ010.D_E_L_E_T_ <> '*'
            `;

            // Adicionar o parâmetro `@branch_code`
            const result_cost = await pool.request()
                .input("branch_code", branch_code) // Insere o valor de `branch_code`
                .query(query_cost);

            // Verificar se há dados retornados
            if (result_geral.recordset.length === 0) {
                throw new Error("Não há dados na tabela SB1010.");
            }
            if (result_cost.recordset.length === 0) {
                throw new Error("Não há dados na tabela SBZ010 para o branch_code especificado.");
            }

            // Iterar pelos resultados e inserir no Prisma
            const imported_data_geral = result_geral.recordset;
            const imported_data_cost = result_cost.recordset;

            for (const record of imported_data_geral) {
                const { B1_DESC, B1_COD, B1_CODBAR, B1_ESPECIF } = record;

                // Inserir no banco usando Prisma
                await prismaClient.product.create({
                    data: {
                        name: B1_DESC.trim(),
                        code: B1_COD.trim(),
                        codBar: B1_CODBAR.trim(),
                        description: B1_ESPECIF.trim(),
                        cost: 0
                    },
                });
            }

            for (const record of imported_data_cost) {
                const { BZ_COD, BZ_CUSTD, BZ_FILIAL, BZ_LOCPAD } = record;

                const product = await prismaClient.product.findFirst({
                    where: {
                        code: BZ_COD.toString().trim(),
                    },
                });

                if (product) {
                    await prismaClient.product.update({
                        where: {
                            id: product.id,
                        },
                        data: {
                            cost: BZ_CUSTD,
                            branch_code: BZ_FILIAL.trim(),
                            storage_code: BZ_LOCPAD.trim()
                        },
                    });
                }
            }

            console.log("Dados importados com sucesso.");
            return { imported_data_geral, imported_data_cost };
        } catch (error) {
            console.error("Erro ao importar dados do SQL Server:", error);
            throw new Error("Failed to import data from SQL Server.");
        }
    }
}
