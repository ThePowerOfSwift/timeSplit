'use strict';

Object.defineProperty(exports, "__esModule", {
  value: true
});

var _mongoose = require('mongoose');

var _mongoose2 = _interopRequireDefault(_mongoose);

var _express = require('express');

var _effect = require('../model/effect');

var _effect2 = _interopRequireDefault(_effect);

var _comment = require('../model/comment');

var _comment2 = _interopRequireDefault(_comment);

var _bodyParser = require('body-parser');

var _bodyParser2 = _interopRequireDefault(_bodyParser);

var _authMiddleware = require('../middleware/authMiddleware');

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

exports.default = function (_ref) {
  var config = _ref.config,
      db = _ref.db;

  var api = (0, _express.Router)();

  // '/v1/effect' - GET all effects
  api.get('/', function (req, res) {
    _effect2.default.find({}, function (err, effects) {
      if (err) {
        res.send(err);
      }
      res.json(effects);
    });
  });

  // '/v1/effects/:id' - GET a specific effect
  api.get('/:id', function (req, res) {
    _effect2.default.findById(req.params.id, function (err, effect) {
      if (err) {
        res.send(err);
      }
      res.json(effect);
    });
  });

  // '/v1/effect/category/:category' - Get category
  api.get('/effect/:category', function (req, res) {
    _effect2.default.find({ category: req.params.effect }, function (err, effect) {
      if (err) {
        res.send(err);
      }
      res.json(effect);
    });
  });

  // '/v1/effect/add' - POST - add a effect
  api.post('/add', _authMiddleware.authenticate, function (req, res) {
    var newEffect = new _effect2.default();
    newEffect.name = req.body.name;
    newEffect.category = req.body.category;
    newEffect.description = req.body.description;
    newEffect.effectedDate = req.body.effectedDate;
    newEffect.save(function (err) {
      if (err) {
        res.send(err);
      }
      res.json({ message: 'Effect saved successfully' });
    });
  });

  // '/v1/effect/:id' - DELETE - remove a effect
  api.delete('/:id', _authMiddleware.authenticate, function (req, res) {
    _effect2.default.findById(req.params.id, function (err, effect) {
      if (err) {
        res.status(500).send(err);
        return;
      }
      if (effect === null) {
        res.status(404).send("Effect not found");
        return;
      }
      _effect2.default.remove({
        _id: req.params.id
      }, function (err, effect) {
        if (err) {
          res.status(500).send(err);
          return;
        }
        _comment2.default.remove({
          effect: req.params.id
        }, function (err, comment) {
          if (err) {
            res.send(err);
          }
          res.json({ message: "Effect and Comment Successfully Removed" });
        });
      });
    });
  });

  // '/v1/effect/:id' - PUT - update an existing record
  api.put('/:id', _authMiddleware.authenticate, function (req, res) {
    _effect2.default.findById(req.params.id, function (err, effect) {
      if (err) {
        res.send(err);
      }
      effect.name = req.body.name;
      effect.category = req.body.category;
      effect.description = req.body.description;
      effect.effectedDate = req.body.effectedDate;
      effect.save(function (err) {
        if (err) {
          res.send(err);
        }
        res.json({ message: 'Effect info updated' });
      });
    });
  });

  // add a comment by a specific effect id
  // '/v1/effect/comments/add/:id'
  api.post('/comment/add/:id', _authMiddleware.authenticate, function (req, res) {
    _effect2.default.findById(req.params.id, function (err, effect) {
      if (err) {
        res.send(err);
      }
      var newComment = new _comment2.default();

      newComment.title = req.body.title;
      newComment.text = req.body.text;
      newComment.comment = effect._id;
      newComment.save(function (err, comment) {
        if (err) {
          res.send(err);
        }
        effect.comment.push(newComment);
        effect.save(function (err) {
          if (err) {
            res.send(err);
          }
          res.json({ message: 'Effect Comment saved' });
        });
      });
    });
  });

  // get comments for a specific effect id
  // '/v1/effect/comments/:id'
  api.get('/comments/:id', function (req, res) {
    _comment2.default.find({ effect: req.params.id }, function (err, comments) {
      if (err) {
        res.send(err);
      }
      res.json(comments);
    });
  });

  return api;
};
//# sourceMappingURL=effect.js.map