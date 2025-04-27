const http = require('http');
const path = require('path');
const fs = require('fs');

// Create a simple HTTP server
const server = http.createServer((req, res) => {
  console.log(`Request received: ${req.method} ${req.url}`);
  
  // Handle API test endpoint
  if (req.url === '/api/test') {
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({ message: 'API is working!' }));
    return;
  }
  
  // Serve static files from public directory
  let filePath = path.join(__dirname, '../public', req.url === '/' ? 'index.html' : req.url);
  
  // If the path doesn't have an extension, assume it's a route and serve index.html
  if (!path.extname(filePath)) {
    filePath = path.join(__dirname, '../public', 'index.html');
  }
  
  const extname = path.extname(filePath);
  let contentType = 'text/html';
  
  // Set content type based on file extension
  switch (extname) {
    case '.js':
      contentType = 'text/javascript';
      break;
    case '.css':
      contentType = 'text/css';
      break;
    case '.json':
      contentType = 'application/json';
      break;
    case '.png':
      contentType = 'image/png';
      break;
    case '.jpg':
      contentType = 'image/jpg';
      break;
  }
  
  // Read file
  fs.readFile(filePath, (err, content) => {
    if (err) {
      if (err.code === 'ENOENT') {
        // Page not found
        fs.readFile(path.join(__dirname, '../public', 'index.html'), (err, content) => {
          if (err) {
            res.writeHead(500);
            res.end('Error loading index.html');
          } else {
            res.writeHead(200, { 'Content-Type': 'text/html' });
            res.end(content, 'utf8');
          }
        });
      } else {
        // Server error
        res.writeHead(500);
        res.end(`Server Error: ${err.code}`);
      }
    } else {
      // Success
      res.writeHead(200, { 'Content-Type': contentType });
      res.end(content, 'utf8');
    }
  });
});

// Start server
const PORT = process.env.PORT || 5000;
server.listen(PORT, '0.0.0.0', () => {
  console.log(`Basic HTTP server running on port ${PORT}`);
  console.log(`Access the website at http://localhost:${PORT}`);
});
