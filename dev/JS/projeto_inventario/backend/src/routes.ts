import { Router } from 'express';
import multer from 'multer';
import uploadConfig from './config/multer'

import { CreateUserController } from './controllers/user/CreateUserController'
import { AuthUserController } from './controllers/user/AuthUserController'
import { DetailuserController } from './controllers/user/DetailUserController'
import { CreateProfileController } from './controllers/profile/CreateProfileController'
import { CreateAccessController } from './controllers/access/CreateAccessController'
import { CreateBranchController } from './controllers/branch/CreateBranchController';
import { isAuthenticated } from './middlewares/isAuthenticated'
import { CreateStorageController } from './controllers/storage/CreateStorageController'
import { ImportAddressController } from './controllers/address/ImportAddressController';
import { DeleteProfileController } from './controllers/profile/DeleteProfileController';
import { AlterProfileController } from './controllers/profile/AlterProfileController';
import { ImportStockController } from './controllers/stock/ImportStockController';
import { ImportAddressedStockController } from './controllers/addressed_stock/ImportAddressedStockController';
import { CreateInventController } from './controllers/invent/CreateInventController';
import { AlterInventController } from './controllers/invent/AlterInventControllrer';
import { DeleteInventController } from './controllers/invent/DeleteInventController';

const router = Router();

const upload = multer(uploadConfig.upload("./tmp"));

//-- ROTAS USER --
router.post('/users', new CreateUserController().handle)
router.post('/session', new AuthUserController().handle)
router.get('/me', isAuthenticated, new DetailuserController().handle)

//-- ROTAS PROFILE
router.post('/profile/add', new CreateProfileController().handle)
router.delete('/profile/remove', isAuthenticated, new DeleteProfileController().handle)
router.post('/profile/alter', isAuthenticated, new AlterProfileController().handle)

//-- ROTAS ACCESS
router.post('/access/add', isAuthenticated, new CreateAccessController().handle)

//-- ROTAS BRANCH
router.post('/branch/add', isAuthenticated, new CreateBranchController().handle)

//-- ROTAS STORAGE
router.post('/storage/add', isAuthenticated, new CreateStorageController().handle)

//-- ROTAS ADDRESS
router.post('/address/import', isAuthenticated, new ImportAddressController().handle)

//-- ROTAS STOCK
router.post('/stock/import', isAuthenticated, new ImportStockController().handle)

//-- ROTAS ADDRESSED STOCK
router.post('/addressed_stock/import', isAuthenticated, new ImportAddressedStockController().handle)

//-- ROTAS INVENT
router.post('/invent/add', isAuthenticated, new CreateInventController().handle)
router.post('/invent/alter', isAuthenticated, new AlterInventController().handle)
router.delete('/invent/delete', isAuthenticated, new DeleteInventController().handle)
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