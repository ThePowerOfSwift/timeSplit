import mongoose from 'mongoose';
import Theory from './theory';
let Schema = mongoose.Schema;

let TheoryCommentSchema = new Schema({
  title: String,
  text: String,
  commentBy: String,
  theory: { type: Schema.Types.ObjectId, ref: 'Theory' }
});

module.exports = mongoose.model('TheoryComment', TheoryCommentSchema);
