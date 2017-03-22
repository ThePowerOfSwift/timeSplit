import mongoose from 'mongoose';
import { Router } from 'express';
import Theory from '../model/theory';
import TheoryComment from '../model/theoryComment';
import bodyParser from 'body-parser';
import passport from 'passport';

import { authenticate } from '../middleware/authMiddleware';

export default({ config, db }) => {
  let api = Router();

  // '/v1/theory' - GET all theories
  api.get('/', (req, res) => {
    Theory.find({}, (err, theories) => {
      if (err) {
        res.send(err);
      }
      res.json(theories);
    });
  });

  // '/v1/theories/:id' - GET a specific theory
  api.get('/:id', (req, res) => {
    Theory.findById(req.params.id, (err, effect) => {
      if (err) {
        res.send(err);
      }
      res.json(theory);
    });
  });

  // '/v1/theory/add' - POST add a theory
    api.post('/add', authenticate, (req, res) => {
      let newTheory = new Theory();
      newTheory.title = req.body.title;
      newTheory.description = req.body.description;
      newTheory.createdBy = req.body.createdBy;
      newTheory.likes = req.body.likes;
      newTheory.save(function(err) {
        if (err) {
          res.send(err);
        }
        res.json({ message: 'Theory saved successfully' });
      });
    });

    // '/v1/theory/:id' - PUT - update an existing record
    api.put('/:id', authenticate, (req, res) => {
      Theory.findById(req.params.id, (err, theory) => {
        if (err) {
          res.send(err);
        }
        theory.title = req.body.title;
        theory.description = req.body.description;
        theory.save(function(err) {
          if (err) {
            res.send(err);
          }
          res.send({ message: 'Theory info updated' });
        });
      });
    });

    // add or remove a like from a specific theory id
    // 'v1/effect/like/:id'
    api.put('/:id', authenticate, (req, res) => {
      Theory.findById(req.params.id, (err, theory) => {
        if (err) {
          res.send(err);
        }
        theory.ikes = req.body.likes;
        theory.save(function(err) {
          if (err) {
            res.send(err);
          }
          res.json({ message: 'Theory like updated' });
        });
      });
    });

    // add a comment by a specific effect id
    // '/v1/theory/comments/add/:id'
    api.post('/comments/add/:id', authenticate, (req, res) => {
      Theory.findById(req.params.id, (err, theory) => {
        if (err) {
          res.send(err);
        }
        let newTheoryComment = new TheoryComment();
        newTheoryComment.title = req.body.title;
        newTheoryComment.text = req.body.text;
        newTheoryComment.commentBy = req.body.commentBy;
        newTheoryComment.theory = theory._id;
        newTheoryComment.save((err, theoryComment) => {
          if (err) {
            res.send(err);
          }
          theory.theoryComments.push(newTheoryComment);
          theory.save(err => {
            if (err) {
              res.send(err);
            }
            res.json({ message: 'Theory Comment saved' });
          });
        });
      });
    });

    //GET comments for a specific theory id
    // '/v1/theory/comments/:id'
    api.get('/comments/:id', (req, res) => {
      TheoryComment.find({theory: req.params.id}, (err, comments) => {
        if (err) {
          res.send(err);
        }
        res.json(comments);
      });
    });

  return api;
}
