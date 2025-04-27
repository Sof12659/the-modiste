const mongoose = require('mongoose');

const AlertSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  designId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Design',
    required: true
  },
  criteria: {
    styleMatch: {
      type: Number,
      default: 80,
      min: 0,
      max: 100
    },
    colorMatch: {
      type: Number,
      default: 80,
      min: 0,
      max: 100
    },
    priceRange: {
      type: Number,
      default: 200
    },
    retailers: [String]
  },
  status: {
    type: String,
    enum: ['active', 'paused', 'expired', 'matches_found'],
    default: 'active'
  },
  priority: {
    type: String,
    enum: ['low', 'medium', 'high'],
    default: 'medium'
  },
  notificationPreferences: {
    email: {
      type: Boolean,
      default: true
    },
    push: {
      type: Boolean,
      default: true
    },
    sms: {
      type: Boolean,
      default: false
    }
  },
  createdAt: {
    type: Date,
    default: Date.now
  },
  expiresAt: {
    type: Date,
    required: true
  }
});

module.exports = mongoose.model('Alert', AlertSchema);
