const { MongoMemoryServer } = require('mongodb-memory-server');
const mongoose = require('mongoose');
const express = require('express');
const cors = require('cors');
const path = require('path');

// Import routes
const userRoutes = require('./routes/users');
const designRoutes = require('./routes/designs');
const alertRoutes = require('./routes/alerts');
const searchRoutes = require('./routes/search');
const seamstressRoutes = require('./routes/seamstresses');
const aiRoutes = require('./routes/ai');

// Initialize express app
const app = express();

// Middleware
app.use(cors());
app.use(express.json({ limit: '50mb' }));
app.use(express.urlencoded({ extended: true }));

// Serve static files from the public directory
app.use(express.static(path.join(__dirname, '../public')));

// API Routes
app.use('/api/users', userRoutes);
app.use('/api/designs', designRoutes);
app.use('/api/alerts', alertRoutes);
app.use('/api/search', searchRoutes);
app.use('/api/seamstresses', seamstressRoutes);
app.use('/api/ai', aiRoutes);

// Serve the frontend for any other routes
app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, '../public/index.html'));
});

// MongoDB setup with in-memory server for testing
async function startServer() {
  try {
    // Create an in-memory MongoDB server
    const mongoServer = await MongoMemoryServer.create();
    const mongoUri = mongoServer.getUri();
    
    console.log(`MongoDB Memory Server URI: ${mongoUri}`);
    
    // Connect to the in-memory database
    await mongoose.connect(mongoUri);
    console.log('Connected to MongoDB Memory Server');
    
    // Create some test data
    await createTestData();
    
    // Start the server
    const PORT = process.env.PORT || 5000;
    app.listen(PORT, '0.0.0.0', () => {
      console.log(`Server running on port ${PORT}`);
      console.log(`Access the website at http://localhost:${PORT}`);
    });
  } catch (error) {
    console.error('Failed to start server:', error);
  }
}

// Create test data for the in-memory database
async function createTestData() {
  try {
    // Import models
    const User = require('./models/User');
    const Design = require('./models/Design');
    const Alert = require('./models/Alert');
    const Product = require('./models/Product');
    const Seamstress = require('./models/Seamstress');
    
    // Create test user
    const testUser = new User({
      name: 'Test User',
      email: 'test@example.com',
      password: '$2a$10$XHvjKGhEktF1XQbNZFOOO.0oQClB0h2EB/vCGqy.WmWGHNBQgW5.q', // hashed 'password123'
    });
    await testUser.save();
    console.log('Test user created');
    
    // Create test designs
    const designs = [
      {
        name: 'Summer Dress',
        user: testUser._id,
        designData: JSON.stringify({
          elements: [
            { type: 'garment', name: 'Dress', color: '#ffb6c1', position: { x: 100, y: 100 } }
          ]
        }),
        thumbnail: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==',
      },
      {
        name: 'Business Casual',
        user: testUser._id,
        designData: JSON.stringify({
          elements: [
            { type: 'garment', name: 'Blazer', color: '#000080', position: { x: 100, y: 100 } },
            { type: 'garment', name: 'Pants', color: '#000080', position: { x: 100, y: 300 } }
          ]
        }),
        thumbnail: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==',
      }
    ];
    
    for (const design of designs) {
      const newDesign = new Design(design);
      await newDesign.save();
    }
    console.log('Test designs created');
    
    // Create test products
    const products = [
      {
        name: 'Floral Summer Dress',
        description: 'Beautiful floral pattern summer dress',
        price: 79.99,
        retailer: 'Fashion Store',
        imageUrl: 'https://example.com/dress1.jpg',
        productUrl: 'https://example.com/products/dress1',
        attributes: {
          color: '#ffb6c1',
          pattern: 'floral',
          style: 'casual',
          garmentType: 'dress'
        }
      },
      {
        name: 'Navy Blue Blazer',
        description: 'Classic navy blue blazer for professional settings',
        price: 129.99,
        retailer: 'Business Attire',
        imageUrl: 'https://example.com/blazer1.jpg',
        productUrl: 'https://example.com/products/blazer1',
        attributes: {
          color: '#000080',
          pattern: 'solid',
          style: 'formal',
          garmentType: 'blazer'
        }
      }
    ];
    
    for (const product of products) {
      const newProduct = new Product(product);
      await newProduct.save();
    }
    console.log('Test products created');
    
    // Create test alerts
    const designIds = await Design.find().select('_id');
    const alerts = [
      {
        user: testUser._id,
        design: designIds[0]._id,
        criteria: {
          priceRange: { min: 0, max: 100 },
          retailers: ['Fashion Store'],
          styles: ['casual']
        },
        status: 'active'
      }
    ];
    
    for (const alert of alerts) {
      const newAlert = new Alert(alert);
      await newAlert.save();
    }
    console.log('Test alerts created');
    
    // Create test seamstresses
    const seamstresses = [
      {
        name: 'Jane Smith',
        email: 'jane@example.com',
        phone: '555-123-4567',
        location: 'New York, NY',
        specialties: ['dresses', 'alterations'],
        rating: 4.8,
        reviews: [
          { user: testUser._id, rating: 5, comment: 'Excellent work!' }
        ]
      }
    ];
    
    for (const seamstress of seamstresses) {
      const newSeamstress = new Seamstress(seamstress);
      await newSeamstress.save();
    }
    console.log('Test seamstresses created');
    
  } catch (error) {
    console.error('Error creating test data:', error);
  }
}

// Start the server
startServer();

module.exports = app;
