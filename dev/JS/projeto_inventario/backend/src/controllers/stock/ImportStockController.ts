import { Request, RequestHandler, Response } from "express";
import { ImportStockService } from "../../services/stock/ImportStockService";
import { DeleteStockService } from "../../services/stock/DeleteStockService";

class ImportStockController {
    handle: RequestHandler = async (req: Request, res: Response) => {
        try {
            const importStockService = new ImportStockService();
            const deleteStockService = new DeleteStockService();

            const stock_del = await deleteStockService.execute();
            const { branch_code } = req.body;
            const stock_imp = await importStockService.execute(branch_code);

            res.json({ stock_imp, stock_del });
        } catch (error: any) {
            console.error(error.message);
            res.status(400).json({ error: error.message });
        }
    }
}

export { ImportStockController };