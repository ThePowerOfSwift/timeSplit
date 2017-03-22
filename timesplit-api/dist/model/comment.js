'use strict';

var _mongoose = require('mongoose');

var _mongoose2 = _interopRequireDefault(_mongoose);

var _effect = require('./effect');

var _effect2 = _interopRequireDefault(_effect);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

var Schema = _mongoose2.default.Schema;

var CommentSchema = new Schema({
  title: {
    type: String,
    required: true
  },
  text: String,
  effect: {
    type: Schema.Types.ObjectId,
    ref: 'effect',
    required: true
  }
});

module.exports = _mongoose2.default.model('Comment', CommentSchema);
//# sourceMappingURL=comment.js.map