import { parse } from "dotenv";
import { connectToSqlServer } from "../../database/sqlServer";
import prismaClient from "../../prisma";

export class ImportStorageService {

    async execute(): Promise<any> {
        let codigo = 0
        try {
            // Conectar ao SQL Server
            const pool = await connectToSqlServer();

            // Query para buscar os dados da tabela no SQL Server
            const query = `
        SELECT NNR_CODIGO, NNR_DESCRI FROM [dbo].[NNR010]
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
                const { NNR_CODIGO, NNR_DESCRI } = record;

                try {
                    codigo = parseInt(NNR_CODIGO)
                } catch (e) {
                    console.log("Erro ao converter o código para inteiro")
                    console.log(e)
                }
                // Inserir no banco usando Prisma
                await prismaClient.storage.create({
                    data: {
                        code: codigo,
                        name: NNR_DESCRI,
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
