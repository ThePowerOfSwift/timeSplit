import mongoose from 'mongoose';
import { Router } from 'express';
import Effect from '../model/effect';
import Comment from '../model/comment';
import Account from '../model/account';
import bodyParser from 'body-parser';
import passport from 'passport';

import { authenticate } from '../middleware/authMiddleware';

export default({ config, db }) => {
  let api = Router();

  // '/v1/effect' - GET all effects
  api.get('/', (req, res) => {
    Effect.find({}, (err, effects) => {
      if (err) {
        res.send(err);
      }
      res.json(effects);
    });
  });

  // '/v1/effects/:id' - GET a specific effect
  api.get('/:id', (req, res) => {
    Effect.findById(req.params.id, (err, effect) => {
      if (err) {
        res.send(err);
      }
      res.json(effect);
    });
  });

  // '/v1/effect/add' - POST - add a effect
  api.post('/add', authenticate, (req, res) => {
    let newEffect = new Effect();
    newEffect.name = req.body.name;
    newEffect.category = req.body.category;
    newEffect.description = req.body.description;
    newEffect.effectedDate = req.body.effectedDate;
    newEffect.submittedBy = req.body.submittedBy;
    newEffect.likes = req.body.likes,
    newEffect.account = req.user.id,
    newEffect.save(function(err) {
      if (err) {
        res.send(err);
      }
      res.json({ message: 'Effect saved successfully' });
    });
  });

  // '/v1/effect/:id' - DELETE - remove a effect
  api.delete('/:id', authenticate, (req, res) => {
    Effect.findById(req.params.id, (err, effect) => {
      if (err) {
        res.status(500).send(err);
        return;
      }
      if (effect === null) {
        res.status(404).send("Effect not found");
        return;
      }
      Effect.remove({
        _id: req.params.id
      }, (err, effect) => {
        if (err) {
          res.status(500).send(err);
          return;
        }
        Comment.remove({
          effect: req.params.id
        }, (err, comment) => {
          if (err) {
            res.send(err);
          }
          res.json({message: "Effect and Comment Successfully Removed"});
        });
      });
    });
  });

  // '/v1/effect/:id' - PUT - update an existing record
  api.put('/:id', authenticate, (req, res) => {
    Effect.findById(req.params.id, (err, effect) => {
      if (err) {
        res.send(err);
      }
      effect.name = req.body.name;
      effect.category = req.body.category;
      effect.description = req.body.description;
      effect.effectedDate = req.body.effectedDate;
      effect.save(function(err) {
        if (err) {
          res.send(err);
        }
        res.json({ message: 'Effect info updated' });
      });
    });
  });

  // add or remove a ilke from a specific effect id
  // 'v1/effect/like/:id'
  api.put('/:id', authenticate, (req, res) => {
    Effect.findById(req.params.id, (err, effect) => {
      if (err) {
        res.send(err);
      }
      effect.likes = req.body.likes;
      effect.save(function(err) {
        if (err) {
          res.send(err);
        }
        res.json({ message: 'Effect like updated' });
      });
    });
  });

  // add a comment by a specific effect id
  // '/v1/effect/comments/add/:id'
  api.post('/comments/add/:id', authenticate, (req, res) => {
    Effect.findById(req.params.id, (err, effect) => {
      if (err) {
        res.send(err);
      }
      let newComment = new Comment();
      newComment.title = req.body.title;
      newComment.text = req.body.text;
      newComment.commentBy = req.body.commentBy;
      newComment.effect = effect._id;
      newComment.save((err, comment) => {
        if (err) {
          res.send(err);
        }
        effect.comments.push(newComment);
        effect.save(err => {
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
  api.get('/comments/:id', (req, res) => {
    Comment.find({effect: req.params.id}, (err, comments) => {
      if (err) {
        res.send(err);
      }
      res.json(comments);
    });
  });

  return api;
}
