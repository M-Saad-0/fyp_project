const express = require('express');
const router = express.Router();
const itemBorrowedController = require('../controllers/itemBorrowed');

router.get('/', itemBorrowedController.getAllBorrowedItems);
router.get('/user/:userId', itemBorrowedController.getBorrowedByUserId);
router.post('/', itemBorrowedController.borrowItem);
router.put('/:id/return', itemBorrowedController.returnItem);

module.exports = router;
