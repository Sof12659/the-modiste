const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');

const UserSchema = new mongoose.Schema({
  email: {
    type: String,
    required: true,
    unique: true,
    trim: true,
    lowercase: true
  },
  password: {
    type: String,
    required: true
  },
  name: {
    type: String,
    required: true,
    trim: true
  },
  measurements: {
    height: Number,
    weight: Number,
    bust: Number,
    waist: Number,
    hips: Number,
    inseam: Number,
    shoulderWidth: Number,
    armLength: Number
  },
  preferences: {
    favoriteColors: [String],
    favoriteStyles: [String],
    sizingPreferences: {
      tops: String,
      bottoms: String,
      dresses: String,
      shoes: String
    }
  },
  favoriteRetailers: [String],
  createdAt: {
    type: Date,
    default: Date.now
  }
});

// Hash password before saving
UserSchema.pre('save', async function(next) {
  if (!this.isModified('password')) {
    return next();
  }
  
  try {
    const salt = await bcrypt.genSalt(10);
    this.password = await bcrypt.hash(this.password, salt);
    next();
  } catch (error) {
    next(error);
  }
});

// Method to compare passwords
UserSchema.methods.comparePassword = async function(candidatePassword) {
  return await bcrypt.compare(candidatePassword, this.password);
};

module.exports = mongoose.model('User', UserSchema);
