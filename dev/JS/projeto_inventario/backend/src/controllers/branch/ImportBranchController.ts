import { Request, RequestHandler, Response } from "express";
import { ImportBranchService } from "../../services/branch/ImportBranchService";
import { DeleteBranchService } from "../../services/branch/DeleteBranchService";
import { ImportStorageService } from "../../services/storage/ImportStorageService";
import { DeleteStorageService } from "../../services/storage/DeleteStorageService";

class ImportBranchController {

    handle: RequestHandler = async (req: Request, res: Response) => {
        try {

            const importBranchService = new ImportBranchService()
            const deleteBranchService = new DeleteBranchService()
            const importStorageService = new ImportStorageService()
            const deleteStorageService = new DeleteStorageService()

            const {branch_code, address} = req.body

            await deleteStorageService.execute()
            await deleteBranchService.execute()
            const storage_imp = await importStorageService.execute()
            const branch_imp = await importBranchService.execute({
                branch_code, address
            })

            res.json({ storage_imp, branch_imp });

        } catch (error) {
            console.error(error.message);
            res.status(400).json({ error: error.message });
        }

    }
}

export { ImportBranchController }