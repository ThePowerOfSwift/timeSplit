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

  api.get('/', (req, res) => {
    Image.find({}, (err, images) => {
      if (err) {
        res.send(err);
      }
      res.json(images);
    });
  });

  // TEST VERSION
  var storage = multer.diskStorage({
    destination: function (req, file, callback) {
      callback(null, '../uploads');
    },
    filename: function(req, file, callback) {
      var originalname = file.originalname;
      var extension = originalname.split(".");
      var filename = Date.now() + '.' + extension[extension.length-1];
      callback(null, filename);
    }
  });
  var upload = multer({
    storage : storage }).single('upl');

  api.post('../account/', function(req, res) {
    upload(req, res, function(err) {
      if (err) {
        return res.end("Error uploading file.");
      }
      res.json({
          message: 'File uploaded successfully',
          filename: req.file.filename, // + fileExtension,
          url: `${process.env.PWD}/images/${req.file.filename}` //+ fileExtension
        });
        console.log(req.body);
        console.log(req.file);
        res.end("File is uploaded");
      });
  });

  //we are passing two objects in the addImage method.. which is defined above..
  api.get('/:image', function(req, res) {
      const appRoot = process.env.PWD + '/images';
      res.sendFile('/${req.params.image}' , { root : appRoot });
  });

  return api;
}
