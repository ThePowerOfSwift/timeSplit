import mongoose from 'mongoose';
import Effect from './effect';
let Schema = mongoose.Schema;

let LikesSchema = new Schema({
  meta: {
    likes: Number,
  },
  effect: { type: Schema.Types.ObjectId, ref: 'Effect'}
});

module.exports = mongoose.model('Likes', LikesSchema);
