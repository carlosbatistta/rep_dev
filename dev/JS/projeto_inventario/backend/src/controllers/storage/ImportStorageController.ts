import { Response, Request, RequestHandler } from "express";
import { ImportStorageService } from "../../services/storage/ImportStorageService";

export class ImportStorageController {
    handle: RequestHandler = async (req: Request, res: Response) => {
        try {
            const importStorageService = new ImportStorageService();

            const storage = await importStorageService.execute();

            res.json(storage);
        } catch (error: any) {
            console.error(error.message);
            res.status(400).json({ error: error.message });
        }
    }
}