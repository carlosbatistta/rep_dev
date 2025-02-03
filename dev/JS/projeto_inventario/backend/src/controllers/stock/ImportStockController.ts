import { Request, RequestHandler, Response } from "express";
import { ImportStockService } from "../../services/stock/ImportStockService";
import { DeleteStockService } from "../../services/stock/DeleteStockService";
import { DeleteInfoStockService } from "../../services/info_stock/DeleteInforStockService";

class ImportStockController {
    handle: RequestHandler = async (req: Request, res: Response) => {
        try {
            const importStockService = new ImportStockService();
            const deleteStockService = new DeleteStockService();
            const deleteInfoSotckService = new DeleteInfoStockService();

            const stock_del = await deleteStockService.execute();

            // Extraindo o branch_code do corpo da requisição
            const { branch_code, document } = req.body;

            // Deletando os dados da tabela 'info_stock'
            const info_stock_del = await deleteInfoSotckService.execute({ branch_code, document });
            
            // Passando um objeto com branch_code para o service
            const stock_imp = await importStockService.execute({ branch_code, document });

            res.json({ stock_imp, stock_del, info_stock_del });
        } catch (error: any) {
            console.error(error.message);
            res.status(400).json({ error: error.message });
        }
    };
}

export { ImportStockController };
