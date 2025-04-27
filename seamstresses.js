const express = require('express');
const router = express.Router();
const { authenticate } = require('../middleware/auth');
const Seamstress = require('../models/Seamstress');

// @route   GET api/seamstresses
// @desc    Get all seamstresses
// @access  Private
router.get('/', authenticate, async (req, res) => {
  try {
    const seamstresses = await Seamstress.find()
      .sort({ rating: -1 });
    
    res.json(seamstresses);
  } catch (err) {
    console.error(err.message);
    res.status(500).json({ message: 'Server error' });
  }
});

// @route   GET api/seamstresses/nearby
// @desc    Get seamstresses near a location
// @access  Private
router.get('/nearby', authenticate, async (req, res) => {
  try {
    const { longitude, latitude, maxDistance } = req.query;
    
    // Convert parameters to numbers
    const long = parseFloat(longitude);
    const lat = parseFloat(latitude);
    const distance = parseInt(maxDistance) || 10000; // Default to 10km
    
    // Find seamstresses near the location
    const seamstresses = await Seamstress.find({
      'location.coordinates': {
        $near: {
          $geometry: {
            type: 'Point',
            coordinates: [long, lat]
          },
          $maxDistance: distance
        }
      }
    }).sort({ rating: -1 });
    
    res.json(seamstresses);
  } catch (err) {
    console.error(err.message);
    res.status(500).json({ message: 'Server error' });
  }
});

// @route   GET api/seamstresses/location/:city
// @desc    Get seamstresses by city
// @access  Private
router.get('/location/:city', authenticate, async (req, res) => {
  try {
    const seamstresses = await Seamstress.find({
      'location.city': { $regex: new RegExp(req.params.city, 'i') }
    }).sort({ rating: -1 });
    
    res.json(seamstresses);
  } catch (err) {
    console.error(err.message);
    res.status(500).json({ message: 'Server error' });
  }
});

// @route   GET api/seamstresses/specialty/:specialty
// @desc    Get seamstresses by specialty
// @access  Private
router.get('/specialty/:specialty', authenticate, async (req, res) => {
  try {
    const seamstresses = await Seamstress.find({
      specialties: { $regex: new RegExp(req.params.specialty, 'i') }
    }).sort({ rating: -1 });
    
    res.json(seamstresses);
  } catch (err) {
    console.error(err.message);
    res.status(500).json({ message: 'Server error' });
  }
});

// @route   POST api/seamstresses/contact/:id
// @desc    Contact a seamstress about a design
// @access  Private
router.post('/contact/:id', authenticate, async (req, res) => {
  try {
    const { designId, message } = req.body;
    
    // Find seamstress
    const seamstress = await Seamstress.findById(req.params.id);
    
    // Check if seamstress exists
    if (!seamstress) {
      return res.status(404).json({ message: 'Seamstress not found' });
    }
    
    // In a real implementation, this would send a message to the seamstress
    // For now, we'll just return a success message
    
    res.json({ 
      message: 'Contact request sent successfully',
      seamstress: {
        name: seamstress.name,
        email: seamstress.email
      }
    });
  } catch (err) {
    console.error(err.message);
    
    if (err.kind === 'ObjectId') {
      return res.status(404).json({ message: 'Seamstress not found' });
    }
    
    res.status(500).json({ message: 'Server error' });
  }
});

// @route   GET api/seamstresses/:id
// @desc    Get seamstress by ID
// @access  Private
router.get('/:id', authenticate, async (req, res) => {
  try {
    const seamstress = await Seamstress.findById(req.params.id);
    
    // Check if seamstress exists
    if (!seamstress) {
      return res.status(404).json({ message: 'Seamstress not found' });
    }
    
    res.json(seamstress);
  } catch (err) {
    console.error(err.message);
    
    if (err.kind === 'ObjectId') {
      return res.status(404).json({ message: 'Seamstress not found' });
    }
    
    res.status(500).json({ message: 'Server error' });
  }
});

// @route   POST api/seamstresses/:id/reviews
// @desc    Add a review for a seamstress
// @access  Private
router.post('/:id/reviews', authenticate, async (req, res) => {
  try {
    const { rating, comment } = req.body;
    
    // Find seamstress
    const seamstress = await Seamstress.findById(req.params.id);
    
    // Check if seamstress exists
    if (!seamstress) {
      return res.status(404).json({ message: 'Seamstress not found' });
    }
    
    // Check if user has already reviewed this seamstress
    const alreadyReviewed = seamstress.reviews.find(
      review => review.userId.toString() === req.user.id
    );
    
    if (alreadyReviewed) {
      return res.status(400).json({ message: 'You have already reviewed this seamstress' });
    }
    
    // Create new review
    const newReview = {
      userId: req.user.id,
      rating,
      comment,
      date: Date.now()
    };
    
    // Add review to seamstress
    seamstress.reviews.push(newReview);
    
    // Calculate new average rating
    const totalRating = seamstress.reviews.reduce((sum, review) => sum + review.rating, 0);
    seamstress.rating = totalRating / seamstress.reviews.length;
    
    // Save seamstress
    await seamstress.save();
    
    res.json(seamstress);
  } catch (err) {
    console.error(err.message);
    
    if (err.kind === 'ObjectId') {
      return res.status(404).json({ message: 'Seamstress not found' });
    }
    
    res.status(500).json({ message: 'Server error' });
  }
});

module.exports = router;
