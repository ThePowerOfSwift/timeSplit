import mongoose from 'mongoose';
import { Router} from 'express';
import Profile from '../model/profile';
import Image from '../model/image';
import bodyParser from 'body-parser';
import passport from 'passport';
import Account from './account';


import { authenticate } from '../middleware/authMiddleware';

export default({ config, db }) => {
  let api = Router();
  // let image = require('image');

// '/v1/profiles' -  GET all profiles
 api.get('/', (req, res) => {
   Profile.find({}, (err, profiles) => {
     if (err) {
       res.send(err);
     }
     res.json(profiles);
   });
 });

 // '/v1/profiles/:id' - GET a specifc profile
 api.get('/:id', authenticate, (req, res) => {
   Profile.findById(req.params.id, (err, profile) => {
     if (err) {
       res.send(err);
     }
     res.send(profile);
   });
 });

// '/v1/profile/add' - POST - add a profile
api.post('/add', authenticate, (req, res) => {
  let newProfile = new Profile();
  newProfile.name = req.body.name;
  newProfile.bio = req.body.bio;
  // newProfile.profileImage = image._id;
  newProfile.save(function(err) {
    if(err) {
      res.send(err);
    }
    res.json({ message: 'New Profile and ProfileImage saved successfully' });
  });
});

// '/v1/profile/:id' - PUT - update an existing profile
  api.put('/add/:id', authenticate, (req, res) => {
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

// '/v1/profile/:id' - DELETE - remove a profile
  // api.delete('/:id', authenticate, (req, res) => {
  //   Profile.findById(req.params.id, (err, profile) => {
  //     if (err) {
  //       res.status(500).send(err);
  //       return;
  //     }
  //     if (profile === null) {
  //       res.status(404).send("Profile not found");
  //       return;
  //     }
  //     Profile.remove({
  //       _id: req.params.id
  //     }, (err, profile) => {
  //       if (err) {
  //         res.status(500).send(err);
  //         return;
  //       }
  //       res.json({ message: "Profile has been successfully removed" });
  //     });
  //   });
  // });

  return api;
}
