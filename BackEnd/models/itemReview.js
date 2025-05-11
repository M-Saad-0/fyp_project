const mongoose = require("mongoose");

const itemReviewsSchema = new mongoose.Schema({
  itemId: { type: mongoose.Schema.ObjectId, ref: "Item", required: true },
  borrowerId: { type: mongoose.Schema.ObjectId, ref: "User", required: true },
  review: { type: String, required: true }, 
  personRating: { type: Number, required: true },
});

module.exports = mongoose.model("ItemReviews", itemReviewsSchema);
