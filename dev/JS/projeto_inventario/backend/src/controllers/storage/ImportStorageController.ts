import { Request, RequestHandler, Response } from "express";
import { ImportStorageService } from "../../services/storage/ImportSorageService";

class ImportStorageController {
    handle: RequestHandler = async (req: Request, res: Response) => {
        try {
            const { name, branch_id } = req.body;

            const importStorageService = new ImportStorageService();

            const storage = await importStorageService.execute({
                name,
                branch_id
            });

            res.json(storage);
        } catch (error: any) {
            console.error(error.message);
            res.status(400).json({ error: error.message });
        }
    }
}