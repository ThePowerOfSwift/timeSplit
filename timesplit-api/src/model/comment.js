import mongoose from 'mongoose';
import Effect from './effect';
let Schema = mongoose.Schema;

let CommentSchema = new Schema({
  title: String,
  text: String,
  commentBy: String,
  effect: {type: Schema.Types.ObjectId, ref: 'Effect'}
});

module.exports = mongoose.model('Comment', CommentSchema);
