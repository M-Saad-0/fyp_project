const ItemReviews = require('../models/itemReview');
const User = require("../models/user");

const handleError = (res, error, statusCode = 500, message = "Internal Server Error") => {
  res.status(statusCode).json({
    code: statusCode,
    message: message,
    details: error.message || error,
  });
};

exports.getAllReviews = async (req, res) => {
  try {
    const reviews = await ItemReviews.find();
    res.status(200).json(reviews);
  } catch (error) {
    handleError(res, error, 500, "Failed to retrieve all reviews");
  }
};

exports.getReviewsByItemId = async (req, res) => {
  try {
    const reviews = await ItemReviews.find({ itemId: req.params.itemId });
    const users = await User.find({ userId: { $in: reviews.map(review => review.userId)}})
    res.status(200).json({ reviews, users });
  } catch (error) {
    handleError(res, error, 500, "Failed to retrieve reviews for the item");
  }
};

exports.addReview = async (req, res) => {
  try {
    const review = new ItemReviews(req.body);
    const savedReview = await review.save();
    res.status(201).json(savedReview);
  } catch (error) {
    handleError(res, error, 500, "Failed to add review");
  }
};

exports.deleteReview = async (req, res) => {
  try {
    const review = await ItemReviews.findByIdAndDelete(req.params.id);
    if (!review) return handleError(res, "Review not found", 404);
    
    res.status(200).json({ message: "Review deleted successfully" });
  } catch (error) {
    handleError(res, error, 500, "Failed to delete review");
  }
};
