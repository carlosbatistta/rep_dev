import { Router } from 'express';
import multer from 'multer';

import { CreateUserController } from './controllers/user/CreateUserController'
import { AuthUserController } from './controllers/user/AuthUserController'
import { DetailuserController } from './controllers/user/DetailUserController'
import { CreateProfileController } from './controllers/profile/CreateProfileController'
import { CreateAccessController } from './controllers/access/CreateAccessController'
import { CreateBranchController } from './controllers/branch/CreateBranchController';
import { isAuthenticated } from './middlewares/isAuthenticated'
import { ImportStorageController } from './controllers/storage/ImportStorageController'

import uploadConfig from './config/multer'

const router = Router();

const upload = multer(uploadConfig.upload("./tmp"));

//-- ROTAS USER --
router.post('/users', new CreateUserController().handle)
router.post('/session', new AuthUserController().handle)
router.get('/me', isAuthenticated, new DetailuserController().handle)

//-- ROTAS PROFILE
router.post('/profile', new CreateProfileController().handle)

//-- ROTAS ACCESS
router.post('/access', isAuthenticated, new CreateAccessController().handle)

//-- ROTAS BRANCH
router.post('/branch', isAuthenticated, new CreateBranchController().handle)

//-- ROTAS STORAGE
router.post('/storage', new ImportStorageController().handle)
/*
router.get('/category', isAuthenticated, new ListCategoryController().handle)

//-- ROTAS PRODUCT
router.post('/product', isAuthenticated, upload.single('file'), new CreateProductController().handle)

router.get('/category/product', isAuthenticated, new ListByCategoryController().handle)

//-- ROTAS ORDER
router.post('/order', isAuthenticated, new CreateOrderController().handle)
router.delete('/order', isAuthenticated, new RemoveOrderController().handle)

router.post('/order/add', isAuthenticated, new AddItemController().handle)
router.delete('/order/remove', isAuthenticated, new RemoveItemController().handle)

router.put('/order/send', isAuthenticated, new SendOrderController().handle)

router.get('/orders', isAuthenticated, new ListOrdersController().handle)
router.get('/order/detail', isAuthenticated, new DetailOrderController().handle)

router.put('/order/finish', isAuthenticated, new FinishOrderController().handle)
*/


export { router }; 