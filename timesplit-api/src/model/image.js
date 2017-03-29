import mongoose from 'mongoose';
let Schema = mongoose.Schema;

let ImageSchema = new Schema({
  fieldname: String,
  originalname: String,
  encoding: String,
  mimetype: String,
  destination: String,
  filename: String,
  path: String,
  size: Number,
  created_at: Date,
  updated_at: Date
});

module.exports = mongoose.model('Image', ImageSchema);
