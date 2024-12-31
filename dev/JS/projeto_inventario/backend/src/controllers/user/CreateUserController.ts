import {Request, Response} from 'express'
import { CreateUserService } from '../../services/user/CreateUserService'

class CreateUserController{
  async handle(req: Request, res: Response): Promise<Response>{
    // o req recebe dodos os dados do body via json
    const { name, email, password, profile } = req.body;

    const createUserService = new CreateUserService();

    const user = await createUserService.execute({
      name,
      email,
      password,
      profile,
    });

    return res.json(user)
  }
}

export { CreateUserController }