import mongoose from 'mongoose';
const Schema = mongoose.Schema;
import passportLocalMongoose from 'passport-local-mongoose';
import Effect from './effect';
import Theory from './theory';
import Image from './image';

let Account = new Schema({
  email: String,
  password: String,
  name: String,
  bio: String,
  website: String,
  profileImage: {type: Schema.Types.ObjectId, ref: 'Image'}
});

Account.plugin(passportLocalMongoose);
module.exports = mongoose.model('Account', Account);
