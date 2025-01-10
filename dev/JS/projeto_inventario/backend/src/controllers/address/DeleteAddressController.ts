import { Request, Response, RequestHandler } from "express";
import { DeleteAddressService } from "../../services/address/DeleteAddressService";

class DeleteAddressController {
    handle: RequestHandler = async (req: Request, res: Response) => {
        try {
            const { id } = req.body;

            const deleteAddressService = new DeleteAddressService();

            const address = await deleteAddressService.execute();

            res.json(address);
        } catch (error: any) {
            console.error(error.message);
            res.status(400).json({ error: error.message });
        }
    }
}

export { DeleteAddressController };
