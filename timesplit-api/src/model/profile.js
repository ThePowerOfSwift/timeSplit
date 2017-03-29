import mongoose from 'mongoose';
import Account from './account';
import Likes from './likes';
import Comment from './comment';
import TheoryComment from './theoryComment';
import Image from './image';
let Schema = mongoose.Schema;

let ProfileSchema = new Schema({
  name: {
    type: String,
    required: true
  },
  bio: {
    type: String
  },
  website: String,
  profileImageURL: String,
  // profileImage: { type: Schema.Types.ObjectId, ref: 'Image' },

  // likes: [{ type: Schema.Types.ObjectId, ref: 'Likes'}],
  // comments: [{ type: Schema.Types.ObjectId, ref: 'Comments' }],
  // theoryComments: [{ type: Schema.Types.ObjectId, ref: 'TheoryComment' }],
  account: { type: Schema.Types.ObjectId, ref: 'Account' }
});

module.exports = mongoose.model('Profile', ProfileSchema);

// module.exports.createUser = function (newUser, callback) {
//   newUser.save(callback);
// }
