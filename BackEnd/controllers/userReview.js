const UserReviews = require('../models/userReview');

const handleError = (res, error, statusCode = 500, message = "Internal Server Error") => {
  res.status(statusCode).json({
    code: statusCode,
    message: message,
    details: error.message || error,
  });
};

exports.getAllReviews = async (req, res) => {
  try {
    const reviews = await UserReviews.find();
    res.status(200).json(reviews);
  } catch (error) {
    handleError(res, error, 500, "Failed to retrieve reviews");
  }
};

exports.getReviewsByOwnerId = async (req, res) => {
  try {
    const reviews = await UserReviews.find({ ownerId: req.params.ownerId });
    res.status(200).json(reviews);
  } catch (error) {
    handleError(res, error, 500, "Failed to retrieve reviews by owner");
  }
};

exports.addReview = async (req, res) => {
  try {
    const review = new UserReviews(req.body);
    const savedReview = await review.save();
    res.status(201).json(savedReview);
  } catch (error) {
    handleError(res, error, 500, "Failed to add review");
  }
};

exports.deleteReview = async (req, res) => {
  try {
    const review = await UserReviews.findByIdAndDelete(req.params.id);
    if (!review) return handleError(res, "Review not found", 404);
    res.status(200).json({ message: "Review deleted" });
  } catch (error) {
    handleError(res, error, 500, "Failed to delete review");
  }
};
