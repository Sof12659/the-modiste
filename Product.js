const mongoose = require('mongoose');

const ProductSchema = new mongoose.Schema({
  retailerId: {
    type: String,
    required: true
  },
  name: {
    type: String,
    required: true,
    trim: true
  },
  description: {
    type: String,
    trim: true
  },
  price: {
    type: Number,
    required: true
  },
  images: [String],
  url: {
    type: String,
    required: true
  },
  attributes: {
    style: String,
    color: String,
    pattern: String,
    material: String,
    size: [String]
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
ProductSchema.pre('save', function(next) {
  this.updatedAt = Date.now();
  next();
});

module.exports = mongoose.model('Product', ProductSchema);
