import mongoose from 'mongoose';
import Comment from './comment';
import Account from './account';
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
  likes: {
    type: Number
  },
  submittedBy: {
    type: String,
    required: true
  },
  // submittedBy: {
  //   type: Schema.Types.Name, ref: 'Account'
  //   required: true
  // },
  account: { type: Schema.Types.ObjectId, ref: 'Account'},
  comments: [{type: Schema.Types.ObjectId, ref: 'Comment'}]
});

module.exports = mongoose.model('Effect', EffectSchema);
