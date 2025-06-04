





const express = require('express');
const router = express.Router();
const itemController = require('../controllers/item');

router.get('/query', itemController.searchItems);
router.get('/itemCount', itemController.getSpecificItemCount);
router.get('/', itemController.getAllItems);
router.get('/:itemId', itemController.getItemById);
router.post('/', itemController.createItem);
router.put('/:itemId', itemController.updateItem);
router.delete('/:itemId', itemController.deleteItem);
router.get('/userItems/:userId', itemController.getItemsByUserId);

module.exports = router;
