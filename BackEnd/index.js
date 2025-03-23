const express = require('express');
require('./configs/db');
const app = express();


const userRoutes = require('./routes/user');
const userReviewRoutes = require('./routes/userReview');
const itemRoutes = require('./routes/item');
const itemReviewRoutes = require('./routes/itemReview');
const userLocationRoutes = require('./routes/userLocation');
const itemBorrowedRoutes = require('./routes/itemBorrowed');


app.use(express.json());


app.use('/api/v1/users', userRoutes);
app.use('/api/v1/user-reviews', userReviewRoutes);
app.use('/api/v1/items', itemRoutes);
app.use('/api/v1/item-reviews', itemReviewRoutes);
app.use('/api/v1/user-locations', userLocationRoutes);
app.use('/api/v1/borrowed-items', itemBorrowedRoutes);


const PORT = process.env.PORT || 4000;
app.listen(PORT, '0.0.0.0',() => console.log(`Server running on port ${PORT}`));
