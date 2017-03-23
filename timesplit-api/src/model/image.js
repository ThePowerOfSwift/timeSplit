import mongoose from 'mongoose';
let Schema = mongoose.Schema;

// path and originalname are the fields stored in MongoDB
let ImageSchema = new Schema({
  path: {
    type: String,
    required: true,
    trim: true
  },
  originalname: {
    type: String,
    required: true
  }
});

module.exports = mongoose.model('Image', ImageSchema);
