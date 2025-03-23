const ItemBorrowed = require('../models/itemBorrowed');
const Item = require('../models/item');

const handleError = (res, error, statusCode = 500, message = "Internal Server Error") => {
  res.status(statusCode).json({
    code: statusCode,
    message: message,
    details: error.message || error,
  });
};

exports.getAllBorrowedItems = async (req, res) => {
  try {
    const borrowedItems = await ItemBorrowed.find();
    res.status(200).json(borrowedItems);
  } catch (error) {
    handleError(res, error, 500, "Failed to retrieve borrowed items");
  }
};

exports.getLentedByUserId = async (req, res) => {
  try {
    const lentedItems = await ItemBorrowed.find({ lenderId: req.params.userId });
    res.status(200).json(lentedItems);
  } catch (error) {
    handleError(res, error, 500, "Failed to retrieve lented items");
  }
};

exports.getBorrowedByUserId = async (req, res) => {
  try {
    const borrowedItems = await ItemBorrowed.find({ borrowerId: req.params.userId });
    res.status(200).json(borrowedItems);
  } catch (error) {
    handleError(res, error, 500, "Failed to retrieve borrowed items");
  }
};

exports.borrowItem = async (req, res) => {
  try {
    const borrowedItem = new ItemBorrowed(req.body);
    const savedBorrowedItem = await borrowedItem.save();
    if (!savedBorrowedItem) return handleError(res, "Item not borrowed", 404);

    await Item.findByIdAndUpdate(req.body.itemId, { isRented: true });

    res.status(201).json(savedBorrowedItem);
  } catch (error) {
    handleError(res, error, 500, "Failed to borrow item");
  }
};

exports.returnItem = async (req, res) => {
  try {
    const updatedBorrowedItem = await ItemBorrowed.findByIdAndUpdate(
      req.params.id,
      { returnDate: req.body.returnDate },
      { new: true }
    );

    if (!updatedBorrowedItem) return handleError(res, "Borrow record not found", 404);

    res.status(200).json(updatedBorrowedItem);
  } catch (error) {
    handleError(res, error, 500, "Failed to return item");
  }
};
