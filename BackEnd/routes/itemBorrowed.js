const express = require('express');
const router = express.Router();
const itemBorrowedController = require('../controllers/itemBorrowed');

router.get('/', itemBorrowedController.getAllBorrowedItems);
router.get('/user/lent/:userId', itemBorrowedController.getLentedByUserId);
router.get('/user/borrowed/:userId', itemBorrowedController.getBorrowedByUserId);
router.post('/', itemBorrowedController.borrowItem);
// router.put('/:id/return', itemBorrowedController.returnItem);
router.put('/:id', itemBorrowedController.updatedBorrowedItem);
router.delete('/:id', itemBorrowedController.deleteItemBorrowed);

module.exports = router;