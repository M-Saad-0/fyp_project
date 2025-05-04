const express = require('express');
const router = express.Router();
const itemController = require('../controllers/item');

router.get('/', itemController.getAllItems);
router.get('/:itemId', itemController.getItemById);
router.get('item/search', itemController.searchItems);
router.post('/', itemController.createItem);
router.put('/:itemId', itemController.updateItem);
router.delete('/:itemId', itemController.deleteItem);
router.get('/:userId', itemController.getItemsByUserId);

module.exports = router;
