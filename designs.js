const express = require('express');
const router = express.Router();
const { authenticate } = require('../middleware/auth');
const Design = require('../models/Design');

// @route   POST api/designs
// @desc    Create a new design
// @access  Private
router.post('/', authenticate, async (req, res) => {
  try {
    const { name, designData, thumbnail, tags, views } = req.body;
    
    // Create new design
    const newDesign = new Design({
      userId: req.user.id,
      name,
      designData,
      thumbnail,
      tags,
      views
    });
    
    // Save design to database
    const design = await newDesign.save();
    
    res.status(201).json(design);
  } catch (err) {
    console.error(err.message);
    res.status(500).json({ message: 'Server error' });
  }
});

// @route   GET api/designs
// @desc    Get all designs for current user
// @access  Private
router.get('/', authenticate, async (req, res) => {
  try {
    const designs = await Design.find({ userId: req.user.id }).sort({ createdAt: -1 });
    res.json(designs);
  } catch (err) {
    console.error(err.message);
    res.status(500).json({ message: 'Server error' });
  }
});

// @route   GET api/designs/:id
// @desc    Get design by ID
// @access  Private
router.get('/:id', authenticate, async (req, res) => {
  try {
    const design = await Design.findById(req.params.id);
    
    // Check if design exists
    if (!design) {
      return res.status(404).json({ message: 'Design not found' });
    }
    
    // Check if user owns the design
    if (design.userId.toString() !== req.user.id) {
      return res.status(403).json({ message: 'Not authorized' });
    }
    
    res.json(design);
  } catch (err) {
    console.error(err.message);
    
    if (err.kind === 'ObjectId') {
      return res.status(404).json({ message: 'Design not found' });
    }
    
    res.status(500).json({ message: 'Server error' });
  }
});

// @route   PUT api/designs/:id
// @desc    Update a design
// @access  Private
router.put('/:id', authenticate, async (req, res) => {
  try {
    const { name, designData, thumbnail, tags, views, isFavorite } = req.body;
    
    // Find design
    let design = await Design.findById(req.params.id);
    
    // Check if design exists
    if (!design) {
      return res.status(404).json({ message: 'Design not found' });
    }
    
    // Check if user owns the design
    if (design.userId.toString() !== req.user.id) {
      return res.status(403).json({ message: 'Not authorized' });
    }
    
    // Build update object
    const updateFields = {};
    if (name) updateFields.name = name;
    if (designData) updateFields.designData = designData;
    if (thumbnail) updateFields.thumbnail = thumbnail;
    if (tags) updateFields.tags = tags;
    if (views) updateFields.views = views;
    if (isFavorite !== undefined) updateFields.isFavorite = isFavorite;
    
    // Update design
    design = await Design.findByIdAndUpdate(
      req.params.id,
      { $set: updateFields },
      { new: true }
    );
    
    res.json(design);
  } catch (err) {
    console.error(err.message);
    
    if (err.kind === 'ObjectId') {
      return res.status(404).json({ message: 'Design not found' });
    }
    
    res.status(500).json({ message: 'Server error' });
  }
});

// @route   DELETE api/designs/:id
// @desc    Delete a design
// @access  Private
router.delete('/:id', authenticate, async (req, res) => {
  try {
    // Find design
    const design = await Design.findById(req.params.id);
    
    // Check if design exists
    if (!design) {
      return res.status(404).json({ message: 'Design not found' });
    }
    
    // Check if user owns the design
    if (design.userId.toString() !== req.user.id) {
      return res.status(403).json({ message: 'Not authorized' });
    }
    
    // Delete design
    await design.remove();
    
    res.json({ message: 'Design removed' });
  } catch (err) {
    console.error(err.message);
    
    if (err.kind === 'ObjectId') {
      return res.status(404).json({ message: 'Design not found' });
    }
    
    res.status(500).json({ message: 'Server error' });
  }
});

// @route   GET api/designs/favorites
// @desc    Get all favorite designs for current user
// @access  Private
router.get('/favorites', authenticate, async (req, res) => {
  try {
    const designs = await Design.find({ 
      userId: req.user.id,
      isFavorite: true 
    }).sort({ createdAt: -1 });
    
    res.json(designs);
  } catch (err) {
    console.error(err.message);
    res.status(500).json({ message: 'Server error' });
  }
});

// @route   PUT api/designs/:id/favorite
// @desc    Toggle favorite status of a design
// @access  Private
router.put('/:id/favorite', authenticate, async (req, res) => {
  try {
    // Find design
    let design = await Design.findById(req.params.id);
    
    // Check if design exists
    if (!design) {
      return res.status(404).json({ message: 'Design not found' });
    }
    
    // Check if user owns the design
    if (design.userId.toString() !== req.user.id) {
      return res.status(403).json({ message: 'Not authorized' });
    }
    
    // Toggle favorite status
    design = await Design.findByIdAndUpdate(
      req.params.id,
      { $set: { isFavorite: !design.isFavorite } },
      { new: true }
    );
    
    res.json(design);
  } catch (err) {
    console.error(err.message);
    
    if (err.kind === 'ObjectId') {
      return res.status(404).json({ message: 'Design not found' });
    }
    
    res.status(500).json({ message: 'Server error' });
  }
});

module.exports = router;
