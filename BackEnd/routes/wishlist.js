
const express = require('express');
const { createWishlist, getWishlist, updateWishlist, deleteWishlist, getCurrentState } = require('../controllers/wishlist');

const router = express.Router();


router.post('/', createWishlist);


router.get('/:userId', getWishlist);


router.put('/:userId', updateWishlist);


router.delete('/:userId/:itemId', deleteWishlist);
router.get('/:userId/:itemId', getCurrentState);

module.exports = router;
