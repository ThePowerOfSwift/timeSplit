import mongoose from 'mongoose';
import TheoryComment from './theoryComment';
let Schema = mongoose.Schema;

let TheorySchema = new Schema({
  title: {
    type: String,
    required: true
  },
  description: {
    type: String,
    required: true
  },
  createdBy: {
    type: String,
    required: true
  },
  likes: {
    type: Number
  },
  comments: [{ type: Schema.Types.ObjectId, ref: 'TheoryComment' }]
});

module.exports = mongoose.model('Theory', TheorySchema);
