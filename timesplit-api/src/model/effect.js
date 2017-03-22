import mongoose from 'mongoose';
import Comment from './comment';
let Schema = mongoose.Schema;

let EffectSchema = new Schema({
  name: {
    type: String,
    required: true
  },
  category: {
    type: String,
    required: true
  },
  description: {
    type: String,
    required: true
  },
  effectedDate: {
    type: String
  },
  submittedBy: {
    type: String,
    required: true
  },
  likes: {
    type: Number
  },
  comments: [{type: Schema.Types.ObjectId, ref: 'Comment'}]
});

module.exports = mongoose.model('Effect', EffectSchema);
