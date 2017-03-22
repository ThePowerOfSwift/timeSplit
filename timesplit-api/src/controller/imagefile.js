import mongoose from 'mongoose';
import { Router } from 'express';
import multer from 'multer';
import fs from 'fs';
import path from 'path';


// path and originalname are the fields stored in MongoDB
var imageSchema = mongoose.Schema({
  path: {
    type: String,
    required: true,
    trim: true
  },
  originalname: {
    type: String,
    required: true
  }
});

var Image = module.exports = mongoose.model('files', imageSchema);
  let app = Router();

  app.getImages = function(callback, limit) {
    Image.find(callback).limit(limit);
  }

  app.getImageById = function(id, callback) {
    Image.findById(id. callback);
  }

  app.addImage = function(image, callback) {
    Image.create(image, callback);
  }

  var storage = multer.diskStorage({
    destination: function(req, file, cb) {
      cb(null, 'uploads/')
    },
    filename: function(req, file, cb) {
      cb(null, file.originalname);
    }
  });

  var maxSize = 500000;
  var upload = multer({
    storage: storage,
    limits: { fileSize: maxSize }
  });

  app.get('/', function(req, res, next) {
    res.sender(index.ejs);
  });

  app.post('/', upload.any(), function(req, res, next) {
    res.send(req.files);
    // req.files has the information regarding the file you are uploading
    // from the total information, I am just using the path and the image
    // name to store in the mongo collection(table)
    var path = req.files[0].path;
    var imageName = req.files[0].orginialname;

    var imagepath = {};
    imagepath['path'] = path;
    imagepath['originalname'] = imageName;
    // imagepath contains two object, path and the imageName

    // we are passing two objects in the addImage method.. which is defined
    // above..
    app.addImage(imagepath, function(err) {
    });
  });

  module.exports = app;
