const Item = require('./../models/item');

const handleError = (res, error, statusCode = 500, message = "Internal Server Error") => {
  res.status(statusCode).json({
    code: statusCode,
    message: message,
    details: error.message || error,

  });
};

exports.getAllItems = async (req, res) => {
  try {
    const items = await Item.find();
    res.status(200).json(items);
  } catch (error) {
    handleError(res, error, 500, "Failed to fetch all items");
  }
};

exports.getItemById = async (req, res) => {
  try {
    const item = await Item.findById(req.params.itemId);
    if (!item) return res.status(404).json({ message: 'Item not found' });
    res.status(200).json(item);
  } catch (error) {
    handleError(res, error, 500, "Failed to fetch item by ID");
  }
};

exports.createItem = async (req, res) => {
  try {
    console.log(req.body)
    const newItem = new Item(req.body);
    const savedItem = await newItem.save();
    res.status(201).json(savedItem);
  } catch (error) {
    console.log(error)
    handleError(res, error, 500, "Failed to create new item");
  }
};

exports.updateItem = async (req, res) => {
  try {
    const updatedItem = await Item.findByIdAndUpdate(req.params.itemId, req.body, {
      new: true,
    });
    if (!updatedItem) return res.status(404).json({ message: 'Item not found' });
    res.status(200).json(updatedItem);
  } catch (error) {
    handleError(res, error, 500, "Failed to update item");
  }
};

exports.deleteItem = async (req, res) => {
  try {
    const deletedItem = await Item.findByIdAndDelete(req.params.itemId);
    if (!deletedItem) return res.status(404).json({ message: 'Item not found' });
    res.status(200).json({ message: 'Item deleted' });
  } catch (error) {
    handleError(res, error, 500, "Failed to delete item");
  }
};

exports.getItemsNearMe = async (req, res) => {
  const { userLocation, setNo = 1 } = req.body;

  const ITEMS_PER_PAGE = 20;
  const skip = (setNo - 1) * ITEMS_PER_PAGE;

  try {
    if (!userLocation || !userLocation.lat || !userLocation.lng) {
      return res.status(400).json({ error: { code: 400, message: "Invalid location" } });
    }

    const items = await Item.aggregate([
      {
        $geoNear: {
          near: {
            type: "Point",
            coordinates: [userLocation.lng, userLocation.lat],
          },
          distanceField: "distance",
          spherical: true,
        },
      },
      { $skip: skip },
      { $limit: ITEMS_PER_PAGE },
    ]);

    res.status(200).json(items);
  } catch (error) {
    handleError(res, error, 500, "Failed to fetch items near you");
  }
};


exports.searchItems = async (req, res) => {
  try {
    const searchTerm = req.query.query;
    const longitude = parseFloat(req.query.longitude);
    const latitude = parseFloat(req.query.latitude);

    if (!searchTerm) return handleError(res, null, 400, "No search term provided");

    const items = await Item.find({
      itemName: { $regex: searchTerm, $options: "i" }, 
      location: {
        $near: {
          $geometry: {
            type: "Point",
            coordinates: [longitude, latitude],
          },
          $maxDistance: 10000, 
        },
      },
    });

    if (!items.length) return handleError(res, null, 404, "No medical equipment found");

    res.status(200).json(items);
  } catch (error) {
    handleError(res, error, 500, "Failed to search items");
  }
};

exports.getItemsByUserId = async (req, res) => {
  try {
    const items = await Item.find({ userId: req.params.userId });
    if (!items.length) return res.status(404).json({ message: 'No items found for this user' });
    res.status(200).json(items);
  } catch (error) {
    handleError(res, error, 500, "Failed to fetch items by user ID");
  }
};

exports.getSpecificItemCount = async (req, res) => {
  try {
    console.log(req.query)
    const { itemno, latitude, longitude } = req.query;
    const count = parseInt(itemno) || 10;

    const items = await Item.find({
      location: {
        $near: {
          $geometry: {
            type: 'Point',
            coordinates: [parseFloat(longitude), parseFloat(latitude)]
          },
          $maxDistance: 10000
        }
      }
    }).limit(count);

    if (!items || items.length === 0) {
      return handleError(res, null, 404, "No items found");
    }

    res.status(200).json({'items':items});
  } catch (error) {
    handleError(res, error, 500, "Server error");
  }
};
