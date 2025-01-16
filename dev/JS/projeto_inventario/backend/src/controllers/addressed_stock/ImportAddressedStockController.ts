import { Request, RequestHandler, Response } from "express";
import { ImportAddressedStockService } from "../../services/addressed_stock/ImportAddressedStockService";

class ImportAddressedStockController {
    handle: RequestHandler = async (req: Request, res: Response) => {
        try {
            const importAddressedStockService = new ImportAddressedStockService();

            const { branch_code } = req.body;
            const addressed_stock_imp = await importAddressedStockService.execute({ branch_code });

            res.json({ addressed_stock_imp });
        } catch (error: any) {
            console.error(error.message);
            res.status(400).json({ error: error.message });
        }
    }
}

export { ImportAddressedStockController };