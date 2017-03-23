import mongoose from 'mongoose';
import { Router } from 'express';
import multer from 'multer';
import Image from '../model/image';
import bodyParser from 'body-parser';
import passport from 'passport';
import path from 'path';
import fs from 'fs';

import { authenticate } from '../middleware/authMiddleware';

export default({ config, db }) => {
  let api = Router();

  api.getImages = function(callback, limit) {
    Image.find(callback).limit(limit);
  }

  api.getImageById = function(image, callback) {
    Image.findById(id, callback);
  }

  api.addImage = function(image, callback) {
    Image.create(image, callback);
  }

  // setup multer storage and parameters
  var storage = multer.diskStorage({
    destination: function(req,file,cb) {
      cb(null, 'uploads/')
    },
    filename: function(req,file,cb) {
      cb(null, file.originalname);
    }
  });

  var maxSize = 500000;
  var upload = multer({
    storage: storage,
    limits: { fileSize: maxSize }
  });

  api.get('/', function(req, res, next) {
    res.render('index.ejs');
  });

  api.post('/', upload.any(), function(req, res, next) {
    res.send(req.files);
    // req.files has the information regarding the file you are uploading...
    // from the total information, i am just using the path and the imageName to store in the mongo collection(table)
    var path = req.files[0].path;
    var imageName = req.files[0].originalname;
    var imagepath = {};
    imagepath['path'] = path;
    imagepath['originalname'] = imageName;
    //imagepath contains two objects, path and the imageName

    //we are passing two objects in the addImage method.. which is defined above..
    api.addImage(imagepath, function(err) {
      if (err) {
        res.send(err);
      }
      res.json(error);
    });
  });

  return api;
}
