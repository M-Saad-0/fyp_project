const Wishlist = require('../models/wishList');

const handleError = (res, error, statusCode = 500, message = "Internal Server Error") => {
  res.status(statusCode).json({
    code: statusCode,
    message: message,
    details: error.message || error,
  });
};

exports.createWishlist = async (req, res) => {
  try {
    const wishlist = new Wishlist(req.body);
    await wishlist.save();
    res.status(201).json(wishlist);
  } catch (error) {
    handleError(res, error, 400, "Failed to create wishlist");
  }
};

exports.getWishlist = async (req, res) => {
  try {
    const wishlist = await Wishlist.findOne({ userId: req.params.userId }).populate('items.itemId');
    if (!wishlist) return res.status(404).json({ message: 'Wishlist not found' });
    res.status(200).json(wishlist);
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
    const wishlist = await Wishlist.findOneAndDelete({ userId: req.params.userId });
    if (!wishlist) return res.status(404).json({ message: 'Wishlist not found' });
    res.status(200).json({ message: 'Wishlist deleted successfully' });
  } catch (error) {
    handleError(res, error);
  }
};
