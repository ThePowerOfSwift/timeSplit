import mongoose from 'mongoose';
// import config from './config';

export default callback => {
  mongoose.Promise = global.Promise;
  let db = mongoose.connect('mongodb://localhost:27017/timesplit-api');
  callback(db);
}
