import mongoose from 'mongoose';
import { Router } from 'express';
import Image from '../model/image';
import bodyParser from 'body-parser';
import config from '../config';
import routes from '../routes';
import passport from 'passport';
import path from 'path';
var fs = require('fs');
var multer = require('multer');

import { authenticate } from '../middleware/authMiddleware';

export default({ config, db }) => {
  let api = Router();

  // api.set('views', path.join(__dirname, '../views'));
  // api.set('view engine', 'pug');
  // api.get('/', function(req, res) {
  //   res.render('index', { title: 'Express' });
  // });

  // api.get('/', (req, res) => {
  //   Image.find({}, (err, images) => {
  //     if (err) {
  //       res.send(err);
  //     }
  //     res.json(images);
  //   });
  // });

  // TEST VERSION
  // TEST VERSION
  var storage = multer.diskStorage({
    destination: function (req, file, callback) {
      callback(null, './uploads');
    },
    filename: function(req, file, callback) {
      var originalname = file.originalname;
      var extension = originalname.split(".");
      var filename = Date.now() + '.' + extension[extension.length-1];
      callback(null, filename);
    },

  });

  var upload = multer({ storage : storage });
  var type = upload.single('profile');
  // var Image = require("../model/image")

  api.post('/images', function(req, res) {
    type(req, res, function(err) {
      if (err) {
        res.end("Error uploading file.");
      }
      // Push new ObjectId
      var image = Image(req.file);
      image.id = account._id;
      // image.save(function (err, imageID_DB) {
      //   if (err) {
      //     res.send(err);
      //   }

      image.findByIdAndUpdate(function (err, imageID_DB) {
        if (err) {
          res.send(err);
        }
      }),

        // res.send(imageID_DB);
      // }),
      res.json({
          message: 'File uploaded successfully',
          filename: req.file.filename, // + fileExtension,
          url: `${process.env.PWD}/images/${req.file.filename}`,
          id: image._id
        });
        console.log(req.body);
        console.log(req.file);
        console.log({ id: image._id });
        res.end("File is uploaded");
      });
  });


  //we are passing two objects in the addImage method.. which is defined above..
  // api.get('/images/:id', function(req, res) {
  //     const appRoot = process.env.PWD + '/images';
  //     res.sendFile('/${req.params.image}' , { root : appRoot });
  // });

  // // '/v1/effects/:id' - GET a specific effect
  // api.get('/:id', (req, res) => {
  //   Effect.findById(req.params.id, (err, effect) => {
  //     if (err) {
  //       res.send(err);
  //     }
  //     res.json(effect);
  //   });
  // });

  api.get('/:id', function(req, res) {
    Image.findById(req.params.id, function(err, image) {
      if (err) {
        res.send(err);
      }
      res.json(image);
    });
  });

  function save(req, res) {
    var data = req.body;
    data.id = data.id || new Schema.Types.ObjectID();

    Image.findByIdAndUpdate({ _id: data.id }, data, { upsert:true} )
    .then(() => res.json({ id: data.id }))
    .catch((err) => handleError(err, res, 'Failed to save item'));
  };

  return api;
}

// module.exports = {
//   save: save
// };
