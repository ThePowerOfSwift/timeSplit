import  mongoose from 'mongoose';
import { Router } from 'express';
import Account from '../model/account';
import Effect from './effect';
import Theory from './theory';
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
    Account.register(new Account({
      username: req.body.email,
      name: req.body.name,
      bio: req.body.bio,
      website: req.body.website,
      profileImageURL: req.body.profileImageURL
    }), req.body.password, function(err, account) {
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

  // '/v1/account/me' - GET profile
  api.get('/me', authenticate, (req, res) => {
    var userId = req.user.id;
    res.status(200).json({
      id: req.user.id
    });
  });

  // '/v1/account/profile/'
  api.get ('/profile/', authenticate, (req, res) => {
    var userId = req.user.id;
    var account = req.params.id;
    var userAccount = { userId: account };
    Account.findOne(userAccount, (err, account) => {
      if (err) {
        res.send(err);
      }
      res.status(200).json(account);
    });
  });

  // '/v1/account/profile/:id - GET account profile
  api.get('/profile/:id', authenticate, (req, res) => {
    // var userId = req.params.id;
    Account.findById(req.params.id, (err, account) => {
      if (err) {
        res.send(err);
      }
      res.status(200).json(account);
    });
  });

  // // '/v1/account/update/:id' - UPDATE profile
  // api.put('/update/:id', authenticate, (req, res) => {
  //   var userToUpdate = req.user.id;
  //   // var query = { _id: userToUpdate };
  //     Account.findByIdAndUpdate({ id: userToUpdate },
  //       { $set: {
  //         name: req.body.name,
  //         bio: req.body.bio,
  //         website: req.body.website,
  //         profileImageURL: req.body.profileImageURL
  //       }}, function (err, result) {
  //       if (err) {
  //         return res.send(err);
  //       }
  //         res.json(result);
  //   });
  //      res.send('Successfully updated account info');
  //   });

    // '/v1/account/update/:id' - UPDATE profile
    api.put('/update/:id', authenticate, (req, res) => {
      var userToUpdate = req.params.id;
      // var query = { _id: userToUpdate };
        Account.findById(userToUpdate, function (err, account) {
          if (err) {
            res.status(500).send(err);
          } else {
              account.name = req.body.name || account.name;
              account.bio = req.body.bio || account.bio;
              account.website = req.body.website || account.website;
              account.profileImage = req.body.profileImage || account.profileImage;
              // Save the doc
              account.save(function (err, account) {
                if (err) {
                  res.status(500).send(err)
                }
                var response = {
                  message: "Account Info updated",
                  id: userToUpdate,
                  account
                };
                res.send(response);
              });
            }
          });
      });

  return api;
}
