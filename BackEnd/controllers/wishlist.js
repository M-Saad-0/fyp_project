const Wishlist = require('../models/wishList');
const Item = require('../models/item');

const handleError = (res, error, statusCode = 500, message = "Internal Server Error") => {
  res.status(statusCode).json({
    code: statusCode,
    message: message,
    details: error.message || error,
  });
};

exports.createWishlist = async (req, res) => {
  try {
    const existingWishlist = await Wishlist.findOne({ userId: req.body.userId });
    if (existingWishlist) {
      existingWishlist.items.push({itemId: req.body.item});
      await existingWishlist.save();
      res.status(201).json(existingWishlist);
      return;
    }
    const wishlist = new Wishlist(req.body);
    wishlist.items.push({itemId: req.body.item});

    await wishlist.save();
    res.status(201).json(wishlist);
  } catch (error) {
    handleError(res, error, 400, "Failed to create wishlist");
  }
};

exports.getWishlist = async (req, res) => {
  try {
    const wishlist = await Wishlist.findOne({ userId: req.params.userId });
    let items = [];
    if (!wishlist || wishlist.items.length === 0) {
      return res.status(404).json({ message: 'Wishlist not found' });
    }
    items = await Promise.all(wishlist.items.map(async (item)=>{return Item.findById(item.itemId)}))

    if (!wishlist) return res.status(404).json({ message: 'Wishlist not found' });
    res.status(200).json({'items':items});
  } catch (error) {
    handleError(res, error);
  }
};

exports.updateWishlist = async (req, res) => {
  try {
    const wishlist = await Wishlist.findOneAndUpdate(
      { userId: req.params.userId },
      { $set: req.body },
      { new: true }
    ).populate('items.itemId');

    if (!wishlist) return res.status(404).json({ message: 'Wishlist not found' });
    res.status(200).json(wishlist);
  } catch (error) {
    handleError(res, error, 400, "Failed to update wishlist");
  }
};

exports.deleteWishlist = async (req, res) => {
  try {
    const wishlist = await Wishlist.findOne({ userId: req.params.userId });
    wishlist.items = wishlist.items.filter(item => item.itemId.toString() !== req.params.itemId);
    if (wishlist.items.length === 0) {
      await Wishlist.findOneAndDelete({ userId: req.params.userId });
    } else {
      await wishlist.save();
    }
    if (!wishlist) return res.status(404).json({ message: 'Wishlist not found' });
    res.status(200).json({ message: 'Wishlist deleted successfully' });
  } catch (error) {
    handleError(res, error);
  }
};


exports.getCurrentState = async (req, res) => {
  try {
    const existingWishlist = await Wishlist.findOne({ userId: req.params.userId});
    if (existingWishlist) {
      if(existingWishlist.items.filter(item => item.itemId.toString() === req.params.itemId).length>0){
        return res.status(200).json({ isWishlisted: true });
      }
    }} catch (error) {
    handleError(res, error, 400, "Failed to get current state of wishlist")
  }
  res.status(200).json({ isWishlisted: false });
};