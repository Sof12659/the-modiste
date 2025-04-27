const jwt = require('jsonwebtoken');
const User = require('../models/User');

// Environment variables
const JWT_SECRET = process.env.JWT_SECRET || 'sewreal-secret-key';
const JWT_EXPIRE = process.env.JWT_EXPIRE || '7d';

// Middleware to authenticate token
exports.authenticate = async (req, res, next) => {
  try {
    // Get token from header
    const token = req.header('x-auth-token');
    
    // Check if no token
    if (!token) {
      return res.status(401).json({ message: 'No token, authorization denied' });
    }
    
    // Verify token
    const decoded = jwt.verify(token, JWT_SECRET);
    
    // Add user from payload
    req.user = await User.findById(decoded.id).select('-password');
    
    if (!req.user) {
      return res.status(401).json({ message: 'User not found' });
    }
    
    next();
  } catch (err) {
    res.status(401).json({ message: 'Token is not valid' });
  }
};

// Generate JWT token
exports.generateToken = (userId) => {
  return jwt.sign({ id: userId }, JWT_SECRET, { expiresIn: JWT_EXPIRE });
};
