// safe_sense_backend/server.js
const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');

const app = express();
const PORT = 3000;

// Middleware
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Test route
app.get('/', (req, res) => {
  res.json({ message: 'SafeSense Backend is running!' });
});

// Signup route - receives user credentials
app.post('/api/signup', (req, res) => {
  const { name, age, email, password } = req.body;
  
  console.log('\n===============================');
  console.log('📥 NEW USER SIGNUP');
  console.log('===============================');
  console.log('Name:', name);
  console.log('Age:', age);
  console.log('Email:', email);
  console.log('Password:', password);
  console.log('===============================\n');
  
  // Send success response
  res.status(200).json({
    success: true,
    message: 'User credentials received successfully!',
    data: {
      name,
      age,
      email
    }
  });
});

// Start server
app.listen(PORT, () => {
  console.log(`🚀 SafeSense Backend running on http://localhost:${PORT}`);
  console.log(`📡 Signup endpoint: http://localhost:${PORT}/api/signup`);
});