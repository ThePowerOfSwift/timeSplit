import mongoose from 'mongoose';
import Effect from './effect';
import Profile from './profile';
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
  },
  // effect: [{ type: Schema.Types.ObjectId, ref: 'Effect' }],
  // postedBy: [{ type: Schema.Types.ObjectId, ref: 'Profile' }]
});

module.exports = mongoose.model('Image', ImageSchema);
