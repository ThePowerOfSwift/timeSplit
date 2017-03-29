import  mongoose from 'mongoose';
import { Router } from 'express';
import Account from '../model/account';
import Profile from '../model/profile';
import bodyParser from 'body-parser';
import passport from 'passport';
import config from '../config';

import {generateAccessToken, respond, authenticate} from '../middleware/authMiddleware';

export default ({ config, db }) => {
  let api = Router();

  // '/v1/account'
  api.get('/', (req, res) => {
    res.status(200).send({ user: req.user });
  });

  // '/v1/account/getall' ** REMOVE AFTER DEV
  api.get('/getall', (req, res) => {
    Account.find({}, (err, accounts) => {
      if (err) {
        send(err);
      }
      res.json(accounts);
    });
  });

  // '/v1/account/register'
  api.post('/register', (req, res) => {
    Account.register(new Account({ username: req.body.email}), req.body.password, function(err, account) {
      if (err) {
        if (err.name === "UserExistsError") {
          console.log("User Exists");
          return res.status(409).send(err);
        } else {
          return res.status(500).send(err);
        }
      }

      passport.authenticate(
        'local', {
          session: false
      })(req, res, () => {
        res.status(200).send('Successfully created new account');
      });
    });
  });

  // '/v1/account/login'
  api.post('/login', passport.authenticate(
    'local', {
      session: false,
      scope: []
    }), generateAccessToken, respond);

  // '/v1/account/logout'
  api.get('/logout', authenticate, (req, res) => {
    req.logout();
    res.status(200).send('Successfully logged out');
  });

  api.get('/me', authenticate, (req, res) => {
    res.status(200).json(req.user);
  });

  api.put('/:id', authenticate, (req, res) => {
    var user_id = req.user.id
    Account.findById({ user_id }, function(err, account) {
      let accountInfo = new Account();
      accountInfo.name = req.body.name;
      accountInfo.location = req.body.location;
      accountInfo.website = req.body.website;
      accountInfo.profileImageURL = req.body.profileImageURL;
      accountInfo.save(function(err) {
        if (err) {
          return res.send(err);
        }
        res.json({ message: 'Account info updated'});
      });
    });
  });

  // '/v1/profile/:id' - PUT - update an existing profile
    api.put('/profile/:id', authenticate, (req, res) => {
      Account.findById(req.params.id, (err, account) => {
        if (err) {
          res.send(err);
        }
        let profileInfo = new Profile();
        profileInfo.name = req.body.name;
        profileInfo.bio = req.body.bio;
        profileInfo.website = req.body.website;
        profileInfo.profileImageURL = req.body.profileImageURL;
        profileInfo.account = account._id;
        profileInfo.save((err, profile) => {
          if (err) {
            return res.send(err);
          }
          res.json({ message: 'Profile info has been updated' });
        });
      });
    });

  return api;
}
