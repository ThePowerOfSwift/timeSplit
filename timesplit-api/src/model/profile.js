import mongoose from 'mongoose';
let Schema = mongoose.Schema;

let ProfileSchema = new Schema({
  name: {
    type: String,
    required: true
  },
  bio: {
    type: String
  },
  profileImage: {
    type: String
  }
});

module.exports = mongoose.model('Profile', ProfileSchema);
