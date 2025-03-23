const express = require('express');
const router = express.Router();
const userController = require('./../controllers/user');



router.post('/register', userController.createUser);
router.post('/login', userController.logIn);
router.post('/google-login', userController.loginWithGoogle);
router.get('/:userId', userController.getUser);
router.put('/:userId', userController.updateUser);
router.delete('/:userId', userController.deleteUser);


module.exports = router;