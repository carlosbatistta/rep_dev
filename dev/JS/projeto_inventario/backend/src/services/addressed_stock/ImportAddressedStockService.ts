import { connectToSqlServer } from "../../database/sqlServer";
import prismaClient from "../../prisma";

interface AddressedStockRequest {
    branch_code: string;
}

export class ImportAddressedStockService {

    async execute({ branch_code }: AddressedStockRequest): Promise<any> {


        try {

            // Conectar ao SQL Server
            const pool = await connectToSqlServer();

            // Query para buscar os dados da tabela no SQL Server
            const query_geral = `
            SELECT D14_QTDEST, D14_PRODUT, D14_LOCAL, D14_ENDER,( D14_QTDEPR + D14_QTDSPR) AS transf_quantity, (D14_QTDPEM + D14_QTDEMP) AS reserve_quantity, D14_FILIAL FROM [dbo].[D14010]
            WHERE D14010.D_E_L_E_T_ <> '*'
            AND D14_FILIAL = @branch_code
            `;

            // Executar a query no SQL Server
            const result_geral = await pool.request()
                .input("branch_code", branch_code) // Insere o valor de `branch_code`
                .query(query_geral);

            const query_indicadores = `
            SELECT BZ_COD, BZ_LOCPAD, BZ_CTRWMS, BZ_LOCALIZ FROM [dbo].[SBZ010]
            WHERE SBZ010.D_E_L_E_T_ <> '*'
			AND BZ_FILIAL = @branch_code
            `;
            const result_indicadores = await pool.request()
                .input("branch_code", branch_code) // Insere o valor de `branch_code`
                .query(query_indicadores);

            // Verificar se há dados retornados
            if (result_geral.recordset.length === 0 || result_indicadores.recordset.length === 0) {
                throw new Error("Não há dados.");
            }

            // Iterar pelos resultados e inserir no Prisma
            const imported_data_geral = result_geral.recordset;
            const imported_data_indicadores = result_indicadores.recordset;
            for (const record of imported_data_geral) {
                const { D14_QTDEST, D14_PRODUT, D14_LOCAL, D14_ENDER, D14_FILIAL, transf_quantity, reserve_quantity } = record;

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
                        transfer_quanty: transf_quantity,
                        reserve_quanty: reserve_quantity,
                        address_control: "2",
                        localiz_control: "N",

                    },
                });
            }
            for (const record of imported_data_indicadores) {
                const { BZ_COD, BZ_CTRWMS, BZ_LOCALIZ, BZ_LOCPAD } = record;

                const addressed_stock = await prismaClient.addressed_stock.findFirst({
                    where: {
                        product_code: BZ_COD.toString().trim(),
                        storage_code: BZ_LOCPAD.toString().trim()
                    },
                });
                if (addressed_stock) {
                    await prismaClient.addressed_stock.update({
                        where: {
                            id: addressed_stock.id,
                        },
                        data: {
                            address_control: BZ_CTRWMS,
                            localiz_control: BZ_LOCALIZ.trim()
                        }
                    });
                }
            }
            console.log("Dados importados com sucesso.");
            return { imported_data_geral, imported_data_indicadores };
        } catch (error) {
            console.error("Erro ao importar dados do SQL Server:", error);
            throw new Error("Failed to import data from SQL Server.");
        }
    }
}