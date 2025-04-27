const express = require('express');
const router = express.Router();
const { authenticate } = require('../middleware/auth');
const Alert = require('../models/Alert');
const Design = require('../models/Design');

// @route   POST api/alerts
// @desc    Create a new alert
// @access  Private
router.post('/', authenticate, async (req, res) => {
  try {
    const { designId, criteria, priority, notificationPreferences, expiresAt } = req.body;
    
    // Check if design exists and belongs to user
    const design = await Design.findById(designId);
    if (!design) {
      return res.status(404).json({ message: 'Design not found' });
    }
    
    if (design.userId.toString() !== req.user.id) {
      return res.status(403).json({ message: 'Not authorized' });
    }
    
    // Create new alert
    const newAlert = new Alert({
      userId: req.user.id,
      designId,
      criteria,
      priority,
      notificationPreferences,
      expiresAt
    });
    
    // Save alert to database
    const alert = await newAlert.save();
    
    res.status(201).json(alert);
  } catch (err) {
    console.error(err.message);
    res.status(500).json({ message: 'Server error' });
  }
});

// @route   GET api/alerts
// @desc    Get all alerts for current user
// @access  Private
router.get('/', authenticate, async (req, res) => {
  try {
    const alerts = await Alert.find({ userId: req.user.id })
      .populate('designId', 'name thumbnail')
      .sort({ createdAt: -1 });
    
    res.json(alerts);
  } catch (err) {
    console.error(err.message);
    res.status(500).json({ message: 'Server error' });
  }
});

// @route   GET api/alerts/:id
// @desc    Get alert by ID
// @access  Private
router.get('/:id', authenticate, async (req, res) => {
  try {
    const alert = await Alert.findById(req.params.id)
      .populate('designId', 'name thumbnail designData');
    
    // Check if alert exists
    if (!alert) {
      return res.status(404).json({ message: 'Alert not found' });
    }
    
    // Check if user owns the alert
    if (alert.userId.toString() !== req.user.id) {
      return res.status(403).json({ message: 'Not authorized' });
    }
    
    res.json(alert);
  } catch (err) {
    console.error(err.message);
    
    if (err.kind === 'ObjectId') {
      return res.status(404).json({ message: 'Alert not found' });
    }
    
    res.status(500).json({ message: 'Server error' });
  }
});

// @route   PUT api/alerts/:id
// @desc    Update an alert
// @access  Private
router.put('/:id', authenticate, async (req, res) => {
  try {
    const { criteria, priority, notificationPreferences, status, expiresAt } = req.body;
    
    // Find alert
    let alert = await Alert.findById(req.params.id);
    
    // Check if alert exists
    if (!alert) {
      return res.status(404).json({ message: 'Alert not found' });
    }
    
    // Check if user owns the alert
    if (alert.userId.toString() !== req.user.id) {
      return res.status(403).json({ message: 'Not authorized' });
    }
    
    // Build update object
    const updateFields = {};
    if (criteria) updateFields.criteria = criteria;
    if (priority) updateFields.priority = priority;
    if (notificationPreferences) updateFields.notificationPreferences = notificationPreferences;
    if (status) updateFields.status = status;
    if (expiresAt) updateFields.expiresAt = expiresAt;
    
    // Update alert
    alert = await Alert.findByIdAndUpdate(
      req.params.id,
      { $set: updateFields },
      { new: true }
    );
    
    res.json(alert);
  } catch (err) {
    console.error(err.message);
    
    if (err.kind === 'ObjectId') {
      return res.status(404).json({ message: 'Alert not found' });
    }
    
    res.status(500).json({ message: 'Server error' });
  }
});

// @route   DELETE api/alerts/:id
// @desc    Delete an alert
// @access  Private
router.delete('/:id', authenticate, async (req, res) => {
  try {
    // Find alert
    const alert = await Alert.findById(req.params.id);
    
    // Check if alert exists
    if (!alert) {
      return res.status(404).json({ message: 'Alert not found' });
    }
    
    // Check if user owns the alert
    if (alert.userId.toString() !== req.user.id) {
      return res.status(403).json({ message: 'Not authorized' });
    }
    
    // Delete alert
    await alert.remove();
    
    res.json({ message: 'Alert removed' });
  } catch (err) {
    console.error(err.message);
    
    if (err.kind === 'ObjectId') {
      return res.status(404).json({ message: 'Alert not found' });
    }
    
    res.status(500).json({ message: 'Server error' });
  }
});

// @route   GET api/alerts/status/:status
// @desc    Get alerts by status
// @access  Private
router.get('/status/:status', authenticate, async (req, res) => {
  try {
    const alerts = await Alert.find({ 
      userId: req.user.id,
      status: req.params.status 
    })
      .populate('designId', 'name thumbnail')
      .sort({ createdAt: -1 });
    
    res.json(alerts);
  } catch (err) {
    console.error(err.message);
    res.status(500).json({ message: 'Server error' });
  }
});

// @route   PUT api/alerts/:id/status
// @desc    Update alert status
// @access  Private
router.put('/:id/status', authenticate, async (req, res) => {
  try {
    const { status } = req.body;
    
    // Find alert
    let alert = await Alert.findById(req.params.id);
    
    // Check if alert exists
    if (!alert) {
      return res.status(404).json({ message: 'Alert not found' });
    }
    
    // Check if user owns the alert
    if (alert.userId.toString() !== req.user.id) {
      return res.status(403).json({ message: 'Not authorized' });
    }
    
    // Update status
    alert = await Alert.findByIdAndUpdate(
      req.params.id,
      { $set: { status } },
      { new: true }
    );
    
    res.json(alert);
  } catch (err) {
    console.error(err.message);
    
    if (err.kind === 'ObjectId') {
      return res.status(404).json({ message: 'Alert not found' });
    }
    
    res.status(500).json({ message: 'Server error' });
  }
});

module.exports = router;
