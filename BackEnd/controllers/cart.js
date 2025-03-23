const Cart = require('./../models/cart');

const handleError = (res, error, statusCode = 500, message = "Internal Server Error") => {
  res.status(statusCode).json({
    code: statusCode,
    message: message,
    details: error.message || error,
  });
};

exports.createCart = async (req, res) => {
  try {
    const cart = new Cart(req.body);
    await cart.save();
    res.status(201).json(cart);
  } catch (error) {
    handleError(res, error, 400, "Failed to create cart");
  }
};

exports.getCart = async (req, res) => {
  try {
    const cart = await Cart.findOne({ userId: req.params.userId }).populate('items.itemId');
    if (!cart) return handleError(res, "Cart not found", 404);
    res.json(cart);
  } catch (error) {
    handleError(res, error, 500, "Failed to retrieve cart");
  }
};

exports.updateCart = async (req, res) => {
  try {
    const cart = await Cart.findOneAndUpdate(
      { userId: req.params.userId },
      { $set: req.body },
      { new: true }
    ).populate('items.itemId');
    
    if (!cart) return handleError(res, "Cart not found", 404);
    res.json(cart);
  } catch (error) {
    handleError(res, error, 400, "Failed to update cart");
  }
};

exports.deleteCart = async (req, res) => {
  try {
    const cart = await Cart.findOneAndDelete({ userId: req.params.userId });
    if (!cart) return handleError(res, "Cart not found", 404);
    res.json({ success: true, message: "Cart deleted successfully" });
  } catch (error) {
    handleError(res, error, 500, "Failed to delete cart");
  }
};
