import mongoose from 'mongoose';
import { Router } from 'express';
import Image from '../model/image';
import bodyParser from 'body-parser';
import passport from 'passport';
import path from 'path';
var fs = require('fs');
var multer = require('multer');

import { authenticate } from '../middleware/authMiddleware';

export default({ config, db }) => {
  let api = Router();

  api.get('/', (req, res) => {
    Image.find({}, (err, images) => {
      if (err) {
        res.send(err);
      }
      res.json(images);
    });
  });

  var storage = multer.diskStorage({
    destination: function(req,file,cb) {
      cb(null, 'uploads/')
    },
    filename: function(req,file,cb) {
      cb(null, file.originalname);
    }
  });

  api.post('/', multer({ dest: 'uploads/'}).single('upl'),(req, res) => {

    let fileExtension = path.extname(req.file.originalname);
    const appRoot = process.env.PWD + '/images';
    var file = appRoot + '/' + req.file.filename + fileExtension;
    console.log(req.body);
    console.log(req.file);
    // res.sendStatus(204).end();
    fs.rename(req.file.path, file, (err) => {
      if (err) {
        res.sendStatus(500);
      } else {
        res.json({
          message: 'File uploaded successfully',
          filename: req.file.filename + fileExtension,
            url: `${process.env.PWD}/images/${req.file.filename + fileExtension}`
        });
      }
    });
  });

  //we are passing two objects in the addImage method.. which is defined above..
  api.get('/:image', function(req, res) {
      const appRoot = process.env.PWD + '/images';
      res.sendFile('/${req.params.image}' , { root : appRoot });
  });

  return api;
}
