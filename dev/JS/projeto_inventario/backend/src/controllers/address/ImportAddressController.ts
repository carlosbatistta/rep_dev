import { Request, RequestHandler, Response } from "express";
import { ImportAddressService } from "../../services/address/ImportAddressService";
import { DeleteAddressService } from "../../services/address/DeleteAddressService";

class ImportAddressController {
    handle: RequestHandler = async (req: Request, res: Response) => {
        try {
            const importAddressService = new ImportAddressService();
            const deleteAddressService = new DeleteAddressService();

            const address_del = await deleteAddressService.execute();
            const {branch_code} = req.body;
            const address_imp = await importAddressService.execute(branch_code);

            res.json({ address_imp, address_del });
        } catch (error: any) {
            console.error(error.message);
            res.status(400).json({ error: error.message });
        }
    }
}

export { ImportAddressController };