import { Request, Response, RequestHandler } from 'express'
import { CreateInventService } from '../../services/invent/CreateInventService'

class CreateInventController {
    handle: RequestHandler = async (req: Request, res: Response) => {
        try {
            const { tp_material, document, date_count, date_valid, origin, branch_code, storage_code } = req.body;

            const createInventService = new CreateInventService();

            const invent = await createInventService.execute({
                tp_material,
                document,
                date_count,
                date_valid,
                origin,
                branch_code,
                storage_code
            });
            res.json(invent);
        } catch (error: any) {
            console.error(error.message);
            res.status(400).json({ error: error.message })
        }

    }

}

export { CreateInventController }