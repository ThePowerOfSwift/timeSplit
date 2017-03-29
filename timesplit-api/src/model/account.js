import mongoose from 'mongoose';
const Schema = mongoose.Schema;
import passportLocalMongoose from 'passport-local-mongoose';
// import Profile from './profile';s

let Account = new Schema({
  email: String,
  password: String,
  location: String,
  name: String,
  profileImageURL: String,
  website: String
  // profile: { type: Schema.Types.ObjectId, ref: 'Profile' }
});

Account.plugin(passportLocalMongoose);
module.exports = mongoose.model('Account', Account);
