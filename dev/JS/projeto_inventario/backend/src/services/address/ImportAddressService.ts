import { connectToSqlServer } from "../../database/sqlServer";
import prismaClient from "../../prisma";

export class ImportAddressService {

    async execute({ branch_code }): Promise<any> {
        let status = 0
        const branch = await prismaClient.branch.findFirst({
            where: {
                code: branch_code,
            },
        });

        if (branch.address) {
            try {

                // Conectar ao SQL Server
                const pool = await connectToSqlServer();

                // Query para buscar os dados da tabela no SQL Server
                const query = `
                SELECT BE_LOCALIZ, BE_DESCRIC, BE_STATUS, BE_LOCAL,NNR_DESCRI FROM [dbo].[SBE010]
                INNER JOIN [dbo].[NNR010]
                ON BE_LOCAL= NNR_CODIGO
                WHERE SBE010.D_E_L_E_T_ <> '*'
                AND NNR010.D_E_L_E_T_ <> '*'
                AND BE_STATUS = 1
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
                    const { BE_LOCALIZ, BE_DESCRIC, BE_STATUS, BE_LOCAL, NNR_DESCRI } = record;

                    try {
                        status = parseInt(BE_STATUS)
                    } catch (e) {
                        console.log("Erro ao converter o código para inteiro")
                        console.log(e)
                    }

                    // Inserir no banco usando Prisma
                    const storage = await prismaClient.storage.create({
                        data: {
                            code: BE_LOCAL,
                            name: NNR_DESCRI,
                        },
                    });

                    await prismaClient.address.create({
                        data: {
                            address: BE_LOCALIZ,
                            description: BE_DESCRIC,
                            status: status,
                            storage_code: BE_LOCAL,
                            storage_id: storage.id,
                        },
                    });

                }

                console.log("Dados importados com sucesso.");
                return importedData; // Retornar os dados importados, se necessário
            } catch (error) {
                console.error("Erro ao importar dados do SQL Server:", error);
                throw new Error("Failed to import data from SQL Server.");
            }
        } else {
            try{
                // Conectar ao SQL Server
                const pool = await connectToSqlServer();

                // Query para buscar os dados da tabela no SQL Server
                const query = `
                SELECT NNR_CODIGO, NNR_DESCRI FROM [dbo].[NNR010]
                WHERE NNR010.D_E_L_E_T_ <> '*'
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

                    // Inserir no banco usando Prisma
                    await prismaClient.storage.create({
                        data: {
                            code: NNR_CODIGO,
                            name: NNR_DESCRI,
                        },
                    });
                }


            } catch (error) {
                console.error("Erro ao importar dados do SQL Server:", error);
                throw new Error("Failed to import data from SQL Server.");
            }
        }
    }

}