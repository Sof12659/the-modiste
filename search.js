const express = require('express');
const router = express.Router();
const { authenticate } = require('../middleware/auth');
const Product = require('../models/Product');
const Match = require('../models/Match');
const Design = require('../models/Design');

// @route   POST api/search/products
// @desc    Search for products matching design criteria
// @access  Private
router.post('/products', authenticate, async (req, res) => {
  try {
    const { designId, criteria } = req.body;
    
    // Check if design exists and belongs to user
    const design = await Design.findById(designId);
    if (!design) {
      return res.status(404).json({ message: 'Design not found' });
    }
    
    if (design.userId.toString() !== req.user.id) {
      return res.status(403).json({ message: 'Not authorized' });
    }
    
    // In a real implementation, this would use AI to search for matching products
    // For now, we'll simulate with a mock search
    
    // Extract search criteria
    const { style, color, pattern, priceRange, retailers } = criteria || {};
    
    // Build query
    const query = {};
    if (style) query['attributes.style'] = { $regex: style, $options: 'i' };
    if (color) query['attributes.color'] = { $regex: color, $options: 'i' };
    if (pattern) query['attributes.pattern'] = { $regex: pattern, $options: 'i' };
    if (priceRange) query.price = { $lte: priceRange };
    if (retailers && retailers.length > 0) query.retailerId = { $in: retailers };
    
    // Find matching products
    const products = await Product.find(query).limit(20);
    
    // Create match records for found products
    const matches = [];
    for (const product of products) {
      // Calculate match quality (in a real implementation, this would be done by AI)
      const matchQuality = {
        overall: Math.floor(Math.random() * 30) + 70, // 70-99%
        style: Math.floor(Math.random() * 30) + 70,
        color: Math.floor(Math.random() * 30) + 70,
        pattern: Math.floor(Math.random() * 30) + 70,
        material: Math.floor(Math.random() * 30) + 70
      };
      
      // Create match record
      const match = new Match({
        userId: req.user.id,
        designId,
        productId: product._id,
        matchQuality,
        status: 'new'
      });
      
      await match.save();
      
      // Add match to results
      matches.push({
        match,
        product
      });
    }
    
    // Sort matches by overall match quality
    matches.sort((a, b) => b.match.matchQuality.overall - a.match.matchQuality.overall);
    
    res.json(matches);
  } catch (err) {
    console.error(err.message);
    res.status(500).json({ message: 'Server error' });
  }
});

// @route   GET api/search/matches/status/:status
// @desc    Get matches by status
// @access  Private
router.get('/matches/status/:status', authenticate, async (req, res) => {
  try {
    const matches = await Match.find({ 
      userId: req.user.id,
      status: req.params.status 
    })
      .populate('designId', 'name thumbnail')
      .populate('productId')
      .sort({ createdAt: -1 });
    
    res.json(matches);
  } catch (err) {
    console.error(err.message);
    res.status(500).json({ message: 'Server error' });
  }
});

// @route   GET api/search/matches/:designId
// @desc    Get all matches for a design
// @access  Private
router.get('/matches/:designId', authenticate, async (req, res) => {
  try {
    // Check if design exists and belongs to user
    const design = await Design.findById(req.params.designId);
    if (!design) {
      return res.status(404).json({ message: 'Design not found' });
    }
    
    if (design.userId.toString() !== req.user.id) {
      return res.status(403).json({ message: 'Not authorized' });
    }
    
    // Find matches for the design
    const matches = await Match.find({ 
      userId: req.user.id,
      designId: req.params.designId
    })
      .populate('productId')
      .sort({ 'matchQuality.overall': -1 });
    
    res.json(matches);
  } catch (err) {
    console.error(err.message);
    
    if (err.kind === 'ObjectId') {
      return res.status(404).json({ message: 'Design not found' });
    }
    
    res.status(500).json({ message: 'Server error' });
  }
});

// @route   PUT api/search/matches/:id/status
// @desc    Update match status
// @access  Private
router.put('/matches/:id/status', authenticate, async (req, res) => {
  try {
    const { status } = req.body;
    
    // Find match
    let match = await Match.findById(req.params.id);
    
    // Check if match exists
    if (!match) {
      return res.status(404).json({ message: 'Match not found' });
    }
    
    // Check if user owns the match
    if (match.userId.toString() !== req.user.id) {
      return res.status(403).json({ message: 'Not authorized' });
    }
    
    // Update status
    match = await Match.findByIdAndUpdate(
      req.params.id,
      { $set: { status } },
      { new: true }
    ).populate('productId');
    
    res.json(match);
  } catch (err) {
    console.error(err.message);
    
    if (err.kind === 'ObjectId') {
      return res.status(404).json({ message: 'Match not found' });
    }
    
    res.status(500).json({ message: 'Server error' });
  }
});

module.exports = router;
