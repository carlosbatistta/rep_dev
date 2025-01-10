import { connectToSqlServer } from "../../database/sqlServer";
import prismaClient from "../../prisma";

export class ImportAddressService {

    async execute(): Promise<any> {
        let status = 0
        try {
            // Conectar ao SQL Server
            const pool = await connectToSqlServer();

            // Query para buscar os dados da tabela no SQL Server
            const query = `
        SELECT BE_LOCALIZ, BE_DESCRIC, BE_STATUS, BE_LOCAL FROM [dbo].[SBE010]
        WHERE SBE010.D_E_L_E_T_ <> '*'
        and BE_STATUS = 1
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
                const { BE_LOCALIZ, BE_DESCRIC, BE_STATUS, BE_LOCAL } = record;

                try {
                    status = parseInt(BE_STATUS)
                } catch (e) {
                    console.log("Erro ao converter o código para inteiro")
                    console.log(e)
                }

                const local = await prismaClient.storage.findFirst({
                    where: {
                        code: BE_LOCAL
                    }
                })
                if (local === null) {
                    throw new Error("Armazém inexistente!");
                }
                // Inserir no banco usando Prisma
                await prismaClient.address.create({
                    data: {
                        address: BE_LOCALIZ,
                        description: BE_DESCRIC,
                        status: status,
                        storage_code: local.code,
                        storage_id: local.id,
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