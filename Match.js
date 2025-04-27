const mongoose = require('mongoose');

const MatchSchema = new mongoose.Schema({
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
  productId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Product',
    required: true
  },
  matchQuality: {
    overall: {
      type: Number,
      required: true,
      min: 0,
      max: 100
    },
    style: {
      type: Number,
      min: 0,
      max: 100
    },
    color: {
      type: Number,
      min: 0,
      max: 100
    },
    pattern: {
      type: Number,
      min: 0,
      max: 100
    },
    material: {
      type: Number,
      min: 0,
      max: 100
    }
  },
  status: {
    type: String,
    enum: ['new', 'viewed', 'saved', 'dismissed'],
    default: 'new'
  },
  createdAt: {
    type: Date,
    default: Date.now
  }
});

module.exports = mongoose.model('Match', MatchSchema);
