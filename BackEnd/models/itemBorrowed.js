const mongoose = require('mongoose');

const itemBorrowedSchema = new mongoose.Schema({
  itemId: { 
    type: mongoose.Schema.Types.ObjectId, 
    ref: 'Item',  
    required: true 
  },
  borrowerId: { 
    type: mongoose.Schema.Types.ObjectId, 
    ref: 'User',  
    required: true 
  },
  borrowerId: { 
    type: mongoose.Schema.Types.ObjectId, 
    ref: 'User',  
    required: true 
  },
  paymentMethod: { type: String, required: true },
  borrowDate: { type: Date, required: true },
  returnDate: { type: Date },
});


module.exports = mongoose.model('ItemBorrowed', itemBorrowedSchema);
