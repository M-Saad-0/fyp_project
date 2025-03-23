const UserLocation = require('../models/userLocation');

const handleError = (res, error, statusCode = 500, message = "Internal Server Error") => {
  res.status(statusCode).json({
    code: statusCode,
    message: message,
    details: error.message || error,
  });
};

exports.getAllLocations = async (req, res) => {
  try {
    const locations = await UserLocation.find();
    res.status(200).json(locations);
  } catch (error) {
    handleError(res, error, 500, "Failed to retrieve locations");
  }
};

exports.getLocationByUserId = async (req, res) => {
  try {
    const location = await UserLocation.findOne({ userId: req.params.userId });
    if (!location) return handleError(res, "Location not found", 404);
    res.status(200).json(location);
  } catch (error) {
    handleError(res, error, 500, "Failed to retrieve location");
  }
};

exports.upsertLocation = async (req, res) => {
  try {
    const { userId, latitude, longitude } = req.body;
    const location = await UserLocation.findOneAndUpdate(
      { userId },
      { latitude, longitude, lastModified: Date.now() },
      { new: true, upsert: true }
    );
    res.status(200).json(location);
  } catch (error) {
    handleError(res, error, 500, "Failed to update location");
  }
};

exports.deleteLocation = async (req, res) => {
  try {
    const location = await UserLocation.findOneAndDelete({ userId: req.params.userId });
    if (!location) return handleError(res, "Location not found", 404);
    res.status(200).json({ message: "Location deleted" });
  } catch (error) {
    handleError(res, error, 500, "Failed to delete location");
  }
};
