import {Request, RequestHandler, Response} from 'express';
import { CreateBranchService } from '../../services/branch/CreateBranchService';

class CreateBranchController {
    handle: RequestHandler = async (req: Request, res: Response) => {
        try {
            const { name, code, status, address } = req.body;

            const createBranchService = new CreateBranchService();

            const branch = await createBranchService.execute({
                name,
                code,
                status,
                address
            });

            res.json(branch);
        } catch (error: any) {
            console.error(error.message);
            res.status(400).json({ error: error.message });
        }
    }
}

export { CreateBranchController };

//Apagar clase Delete, alterar de create para import