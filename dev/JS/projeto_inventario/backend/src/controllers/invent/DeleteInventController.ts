import { RequestHandler, Request, Response } from 'express'
import { DeleteInventService } from '../../services/invent/DeleteInventService'

class DeleteInventController {
    handle: RequestHandler = async (req: Request, res: Response) =>{
        try{
            const {id} = req.body

            const deletInventService = new DeleteInventService();

            const invent = await deletInventService.execute({
                id
            })
            res.json(invent)
        }catch (error: any){
            console.error(error.message)
            res.status(400).json({ error: error.message })
        }
    }
}

export {DeleteInventController}