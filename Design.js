const mongoose = require('mongoose');

const DesignSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  name: {
    type: String,
    required: true,
    trim: true
  },
  designData: {
    type: Object,
    required: true
  },
  thumbnail: {
    type: String
  },
  tags: [String],
  isFavorite: {
    type: Boolean,
    default: false
  },
  views: {
    front: String,
    back: String,
    side: String
  },
  createdAt: {
    type: Date,
    default: Date.now
  },
  updatedAt: {
    type: Date,
    default: Date.now
  }
});

// Update the updatedAt timestamp before saving
DesignSchema.pre('save', function(next) {
  this.updatedAt = Date.now();
  next();
});

module.exports = mongoose.model('Design', DesignSchema);
