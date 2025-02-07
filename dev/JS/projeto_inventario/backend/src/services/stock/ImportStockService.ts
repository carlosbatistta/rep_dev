import { connectToSqlServer } from "../../database/sqlServer";
import prismaClient from "../../prisma";

interface StockRequest {
    branch_code: string;
    storage_code: string;
    date_count: string;
    document: number;
}

export class ImportStockService {

    async execute({ branch_code, document, storage_code, date_count }: StockRequest): Promise<any> {

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

        const branch = await prismaClient.branch.findFirst({
            where: {
                code: branch_code,
            }
        })

        try {

            // Conectar ao SQL Server
            const pool = await connectToSqlServer();

            // Query para buscar os dados da tabela no SQL Server
            const query_geral = `
                select B2_QATU, B2_COD, B2_LOCAL, B2_FILIAL, B2_CM1, B2_RESERVA from [dbo].[SB2010]
                where SB2010.D_E_L_E_T_ <> '*'
                and B2_FILIAL = @branch_code
				and B2_COD != ''
                AND B2_LOCAL = @storage_code
                `

            // Executar a query no SQL Server
            const result_geral = await pool.request()
                .input("branch_code", branch_code).input("storage_code", storage_code) // Insere o valor de `branch_code`
                .query(query_geral);

            const query_total = `
                SELECT B2_LOCAL, B2_FILIAL,
                    SUM(B2_QATU) AS total_stock_quantity,
                    ROUND(SUM(B2_QATU * B2_CM1), 2) AS total_stock_value
                FROM 
                    [dbo].[SB2010]
                WHERE 
                    SB2010.D_E_L_E_T_ <> '*'
                    AND B2_FILIAL = @branch_code
                    AND B2_COD != ''
                    AND B2_LOCAL = @storage_code
                GROUP BY 
                    B2_LOCAL, 
                    B2_FILIAL
            `
            const result_total = await pool.request()
                .input("branch_code", branch_code).input("storage_code", storage_code) // Insere o valor de `branch_code`
                .query(query_total);

            const query_indicadores = `
                SELECT 
                    BZ_COD, BZ_LOCPAD, BZ_CTRWMS, BZ_LOCALIZ, BZ_FILIAL
                FROM [dbo].[SBZ010]
                WHERE 
                    SBZ010.D_E_L_E_T_ <> '*'
                    AND BZ_FILIAL = @branch_code
                    AND BZ_LOCPAD = @storage_code
            `
            const result_indicadores = await pool.request()
                .input("branch_code", branch_code).input("storage_code", storage_code) // Insere o valor de `branch_code`
                .query(query_indicadores)

            // Verificar se há dados retornados
            if (result_geral.recordset.length === 0) {
                throw new Error("Não há dados na B2.")
            }

            if (result_indicadores.recordset.length === 0) {
                throw new Error("Não há dados na BZ")
            }

            // Iterar pelos resultados e inserir no Prisma
            const imported_data = result_geral.recordset;
            const imported_data_indicadores = result_indicadores.recordset;
            const imported_data_total = result_total.recordset;
            for (const record of imported_data) {
                const { B2_QATU, B2_COD, B2_LOCAL, B2_FILIAL, B2_CM1, B2_RESERVA } = record;

                const product = await prismaClient.product.findFirst({
                    where: {
                        code: B2_COD.trim(),
                    },
                });

                if (!product) {
                    throw new Error(`Produto ${B2_COD.trim()} não encontrado.`);
                }

                //inserir no banco usando Prisma
                await prismaClient.stock.create({
                    data: {
                        total_quantity: B2_QATU,
                        branch_code: B2_FILIAL.trim(),
                        product_code: product.code,
                        storage_code: B2_LOCAL.trim(),
                        product_desc: product.description,
                        cost: B2_CM1 ?? 0,
                        reservation: B2_RESERVA,
                        address_control: "2",
                        localiz_control: "N",
                        addresed_quantity: 0,
                        unbalanced: false,
                        access_nivel: 0
                    },
                });
                if(branch.address === false){
                await prismaClient.invent_product.create({
                    data: {
                        branch_code: B2_FILIAL.trim(),
                        product_code: product.code,
                        storage_code: B2_LOCAL.trim(),
                        product_desc: product.description,
                        document: document,
                        date_count: date_count,
                        counted: false,
                        access_nivel: 0,
                        status: "NOVO", // replace with actual value
                        situation: "" // replace with actual value
                    }
                })
            }
            }

            for (const record of imported_data_indicadores) {
                const { BZ_COD, BZ_CTRWMS, BZ_LOCALIZ, BZ_LOCPAD, BZ_FILIAL } = record;

                const stock = await prismaClient.stock.findFirst({
                    where: {
                        product_code: BZ_COD.toString().trim(),
                        branch_code: BZ_FILIAL.toString().trim(),
                        storage_code: BZ_LOCPAD.toString().trim(),
                    },
                });
                if (stock) {
                    await prismaClient.stock.update({
                        where: {
                            id: stock.id,
                        },
                        data: {
                            address_control: BZ_CTRWMS.trim(),
                            localiz_control: BZ_LOCALIZ.trim()
                        }
                    });
                }
            }
            for (const record of imported_data_total) {
                const { B2_LOCAL, B2_FILIAL, total_stock_quantity, total_stock_value } = record;
                const info_stock = await prismaClient.info_stock.findFirst({
                    where: {
                        branch_code: B2_FILIAL.trim(),
                        storage_code: B2_LOCAL.trim(),
                        document: document
                    },
                })

                await prismaClient.info_stock.update({
                    where: {
                        id: info_stock.id,
                    },
                    data: {
                        total_stock_quantity: total_stock_quantity,
                        total_stock_value: total_stock_value
                    }
                })
                console.log("Info_stock atualizado")
            }

            console.log("Import Stock (B2, BZ) e invent_stock Efetuado.");
            return imported_data; // Retornar os dados importados, se necessário
        } catch (error) {
            console.error("Erro ao importar dados do SQL Server:", error);
            throw new Error("Failed to import data from SQL Server.");
        }
    }
}
