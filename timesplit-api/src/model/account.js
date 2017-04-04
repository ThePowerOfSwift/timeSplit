import mongoose from 'mongoose';
const Schema = mongoose.Schema;
import passportLocalMongoose from 'passport-local-mongoose';
import Effect from '../model/effect';
import Theory from '../model/theory';
import Image from '../model/image';

let Account = new Schema({
  email: String,
  password: String,
  name: String,
  bio: String,
  website: String,
  profileImageURL: String,
  // effects: { type: Schema.Types.ObjectId, ref: 'Effect'},
  // theories: { type: Schema.Types.ObjectId, ref: 'Theory'}
});

Account.plugin(passportLocalMongoose);
module.exports = mongoose.model('Account', Account);
