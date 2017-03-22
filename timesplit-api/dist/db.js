'use strict';

Object.defineProperty(exports, "__esModule", {
  value: true
});

var _mongoose = require('mongoose');

var _mongoose2 = _interopRequireDefault(_mongoose);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

// import config from './config';

exports.default = function (callback) {
  _mongoose2.default.Promise = global.promise;
  var db = _mongoose2.default.connect('mongodb://localhost:27017/timesplit-api');
  callback(db);
};
//# sourceMappingURL=db.js.map