const express = require('express');
const router = express.Router();
const { authenticate } = require('../middleware/auth');
const designMatchingService = require('../services/designMatchingService');
const Design = require('../models/Design');
const Match = require('../models/Match');
const Product = require('../models/Product');

// @route   POST api/ai/analyze-design
// @desc    Analyze a design image and extract attributes
// @access  Private
router.post('/analyze-design', authenticate, async (req, res) => {
  try {
    const { imageUrl, designId } = req.body;
    
    if (!imageUrl) {
      return res.status(400).json({ message: 'Image URL is required' });
    }
    
    // Check if design exists and belongs to user if designId is provided
    if (designId) {
      const design = await Design.findById(designId);
      if (!design) {
        return res.status(404).json({ message: 'Design not found' });
      }
      
      if (design.userId.toString() !== req.user.id) {
        return res.status(403).json({ message: 'Not authorized' });
      }
    }
    
    // Analyze design using AI service
    const designAttributes = await designMatchingService.analyzeDesign(imageUrl);
    
    res.json(designAttributes);
  } catch (err) {
    console.error('Error in analyze-design:', err);
    res.status(500).json({ message: 'Server error', error: err.message });
  }
});

// @route   POST api/ai/find-matches
// @desc    Find products matching a design
// @access  Private
router.post('/find-matches', authenticate, async (req, res) => {
  try {
    const { designId, designAttributes, criteria } = req.body;
    
    if (!designId && !designAttributes) {
      return res.status(400).json({ message: 'Either designId or designAttributes is required' });
    }
    
    let attributes = designAttributes;
    
    // If designId is provided, check if design exists and belongs to user
    if (designId) {
      const design = await Design.findById(designId);
      if (!design) {
        return res.status(404).json({ message: 'Design not found' });
      }
      
      if (design.userId.toString() !== req.user.id) {
        return res.status(403).json({ message: 'Not authorized' });
      }
      
      // If designAttributes not provided, analyze the design image
      if (!attributes) {
        // In a real implementation, we would extract the image URL from the design
        // For now, we'll use a placeholder
        const imageUrl = design.thumbnail || 'placeholder.jpg';
        attributes = await designMatchingService.analyzeDesign(imageUrl);
      }
    }
    
    // Find matching products
    const matches = await designMatchingService.findMatchingProducts(attributes, criteria);
    
    // If designId is provided, save matches to database
    if (designId) {
      // Save each match to database
      for (const match of matches) {
        // Check if product exists in database, if not, create it
        let product = await Product.findOne({ id: match.product.id });
        if (!product) {
          product = new Product(match.product);
          await product.save();
        }
        
        // Create match record
        const newMatch = new Match({
          userId: req.user.id,
          designId,
          productId: product._id,
          matchQuality: match.scores,
          status: 'new'
        });
        
        await newMatch.save();
      }
    }
    
    res.json(matches);
  } catch (err) {
    console.error('Error in find-matches:', err);
    res.status(500).json({ message: 'Server error', error: err.message });
  }
});

// @route   GET api/ai/color-analysis
// @desc    Analyze colors in an image
// @access  Private
router.get('/color-analysis', authenticate, async (req, res) => {
  try {
    const { imageUrl } = req.query;
    
    if (!imageUrl) {
      return res.status(400).json({ message: 'Image URL is required' });
    }
    
    // Extract dominant colors
    const dominantColors = await designMatchingService.extractDominantColors(imageUrl);
    
    // Analyze color palette
    const colorPalette = designMatchingService.analyzeColorPalette(dominantColors);
    
    res.json({
      dominantColors,
      colorPalette
    });
  } catch (err) {
    console.error('Error in color-analysis:', err);
    res.status(500).json({ message: 'Server error', error: err.message });
  }
});

// @route   POST api/ai/style-match
// @desc    Calculate style match between two designs
// @access  Private
router.post('/style-match', authenticate, async (req, res) => {
  try {
    const { designId1, designId2 } = req.body;
    
    if (!designId1 || !designId2) {
      return res.status(400).json({ message: 'Both design IDs are required' });
    }
    
    // Check if designs exist and belong to user
    const design1 = await Design.findById(designId1);
    const design2 = await Design.findById(designId2);
    
    if (!design1 || !design2) {
      return res.status(404).json({ message: 'One or both designs not found' });
    }
    
    if (design1.userId.toString() !== req.user.id || design2.userId.toString() !== req.user.id) {
      return res.status(403).json({ message: 'Not authorized' });
    }
    
    // In a real implementation, we would analyze both designs and compare them
    // For now, we'll return a simulated match score
    
    const matchScore = Math.floor(Math.random() * 50) + 50; // 50-99%
    
    res.json({
      designId1,
      designId2,
      matchScore
    });
  } catch (err) {
    console.error('Error in style-match:', err);
    res.status(500).json({ message: 'Server error', error: err.message });
  }
});

module.exports = router;
