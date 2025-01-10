import {Request, RequestHandler, Response} from "express";
import {ImportAddressService} from "../../services/address/ImportAddressService";

class ImportAddressController {
    handle: RequestHandler = async (req: Request, res: Response) => {
        try {
            const importAddressService = new ImportAddressService();

            const address = await importAddressService.execute();

            res.json(address);
        } catch (error: any) {
            console.error(error.message);
            res.status(400).json({error: error.message});
        }
    }
}

export {ImportAddressController};