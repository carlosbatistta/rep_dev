import { connectToSqlServer } from "../../database/sqlServer";
import prismaClient from "../../prisma";

interface AddressedStockRequest {
    branch_code: string;
    storage_code: string;
    date_count: string;
    document: number;
}

export class ImportAddressedStockService {

    async execute({ branch_code, document, storage_code, date_count }: AddressedStockRequest): Promise<any> {
        const stock_document = await prismaClient.info_stock.findFirst({
            where: {
                branch_code: branch_code,
                storage_code: storage_code,
                date_count: date_count
            }
        })

        if (document !== stock_document.document) {
            throw new Error("Documentos não correspondem");
        }

        try {

            // Conectar ao SQL Server
            const pool = await connectToSqlServer();

            // Query para buscar os dados da tabela no SQL Server
            const query_geral = `
            SELECT 
                D14_QTDEST, D14_PRODUT, D14_LOCAL, D14_ENDER, D14_FILIAL,
                SUM(D14_QTDEPR + D14_QTDSPR) AS transf_quantity,
                SUM(D14_QTDPEM + D14_QTDEMP) AS reserve_quantity
            FROM [dbo].[D14010]
            WHERE 
                D14010.D_E_L_E_T_ <> '*'
                AND D14_FILIAL = @branch_code
            GROUP BY 
                D14_PRODUT,
				D14_QTDEST,
				D14_ENDER,
                D14_LOCAL, 
                D14_FILIAL
            ORDER BY 
                D14_PRODUT;
            `;

            // Executar a query no SQL Server
            const result_geral = await pool.request()
                .input("branch_code", branch_code) // Insere o valor de `branch_code`
                .query(query_geral);

            const query_quantity = `
            SELECT 
                D14_PRODUT, D14_LOCAL, D14_FILIAL,
                SUM(D14_QTDEST) AS total_quantity
            FROM 
                [dbo].[D14010]
            WHERE 
                D14010.D_E_L_E_T_ <> '*'
                AND D14_FILIAL = @branch_code
            GROUP BY 
                D14_PRODUT, 
                D14_LOCAL, 
                D14_FILIAL
            ORDER BY 
                D14_PRODUT;
            `
            const result_quantity = await pool.request()
                .input("branch_code", branch_code) // Insere o valor de `branch_code`
                .query(query_quantity);


            // Verificar se há dados retornados
            if (result_geral.recordset.length === 0) {
                throw new Error("Não há dados.");
            }

            // Iterar pelos resultados e inserir no Prisma
            const imported_data_geral = result_geral.recordset;
            const imported_data_quantity = result_quantity.recordset;

            for (const record of imported_data_geral) {
                const { D14_QTDEST, D14_PRODUT, D14_LOCAL, D14_ENDER, D14_FILIAL, reserve_quantity, transf_quantity } = record;

                const product = await prismaClient.product.findFirst({
                    where: {
                        code: D14_PRODUT.trim(),
                    },
                });

                if (!product) {
                    throw new Error(`Produto ${D14_PRODUT} não encontrado.`);
                }

                //inserir no banco usando Prisma
                await prismaClient.addressed_stock.create({
                    data: {
                        addressed_quantity: D14_QTDEST,
                        branch_code: D14_FILIAL.trim(),
                        product_code: product.code,
                        storage_code: D14_LOCAL.trim(),
                        product_desc: product.description,
                        address_code: D14_ENDER.trim(),
                        transfer_quantity: transf_quantity,
                        reserve_quantity: reserve_quantity

                    },
                });

                await prismaClient.invent_address.create({
                    data: {
                        branch_code: D14_FILIAL.trim(),
                        product_code: product.code,
                        storage_code: D14_LOCAL.trim(),
                        product_desc: product.description,
                        address_code: D14_ENDER.trim(),
                        document: document,
                        date_count: date_count,
                        status: 'NOVO'
                    }
                })

            }
            for (const record of imported_data_quantity) {
                const { D14_PRODUT, D14_LOCAL, total_quantity } = record;
                const stock = await prismaClient.stock.findFirst({
                    where: {
                        product_code: D14_PRODUT.trim(),
                        storage_code: D14_LOCAL.trim(),
                    }
                });
                if (stock) {
                    let unbalanced
                    if (stock.total_quantity !== total_quantity) {
                        await prismaClient.stock.update({
                            where: {
                                id: stock.id
                            },
                            data: {
                                unbalanced: true
                            }
                        })
                    }
                    await prismaClient.stock.update({
                        where: {
                            id: stock.id
                        },
                        data: {
                            addresed_quantity: total_quantity,
                            unbalanced: unbalanced
                        }
                    })
                }
            }

            console.log("Dados importados com sucesso.");
            return { imported_data_geral, imported_data_quantity };
        } catch (error) {
            console.error("Erro ao importar dados do SQL Server:", error);
            throw new Error("Failed to import data from SQL Server.");
        }
    }
}