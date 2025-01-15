import { connectToSqlServer } from "../../database/sqlServer";
import prismaClient from "../../prisma";

interface ProductRequest {
    branch_id: string;
    branch_code: string;
}

export class ImportProductService {

    async execute({ branch_code }: ProductRequest): Promise<any> {
        let status = 0
        try {
            // Conectar ao SQL Server
            const pool = await connectToSqlServer();

            // Query para buscar os dados da tabela no SQL Server
            const query = `
        SELECT B1_DESC, B1_COD, B1_CODBAR, B1_CUSTD, B1_ESPECIF FROM [dbo].[SB1010]
        WHERE SB1010.D_E_L_E_T_ <> '*'
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
                const { B1_DESC, B1_COD, B1_CODBAR, B1_CUSTD, B1_ESPECIF } = record;

                const branch = await prismaClient.branch.findFirst({
                    where: {
                        code: branch_code
                    }
                })

                // Inserir no banco usando Prisma
                await prismaClient.product.create({
                    data: {
                        name: B1_DESC,
                        code: B1_COD,
                        codBar: B1_CODBAR,
                        cost: B1_CUSTD,
                        description: B1_ESPECIF,
                        branch_code: branch.code,
                        branch_id: branch.id,
                    },
                });
            }
            console.log("Dados importados com sucesso.");
            return importedData;
        } catch (e) {
            console.error("Erro ao importar dados do SQL Server:", error);
            throw new Error("Failed to import data from SQL Server.");
        }
    }
}