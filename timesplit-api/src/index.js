import http from 'http';
import express from 'express';
import bodyParser from 'body-parser';
import mongoose from 'mongoose';
import passport from 'passport';
import path from 'path';
import config from './config';
import routes from './routes';
const LocalStrategy = require('passport-local').Strategy;
import fs from 'fs';
import multer from 'multer';
// import image from './controller/image';


let app = express();
app.server = http.createServer(app);

// middleware
// parse application/json
app.use(bodyParser.json({
  limit: config.bodyLimit
}));

// passport config
app.use(passport.initialize());
let Account = require('./model/account');
passport.use(new LocalStrategy({
  usernameField: 'email',
  passwordField: 'password'
},
  Account.authenticate()
));
passport.serializeUser(Account.serializeUser());
passport.deserializeUser(Account.deserializeUser());
// passport.session();

// api routes v1
app.use('/v1', routes);
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'pug');
app.get('/account/', function(req, res) {
  res.render('index', { title: 'Express' });
});

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
  }
});

// NEW TEST
var upload = multer({ storage : storage });
var type = upload.single('upl');

app.post('/', type, function(req, res) {
      var image = new Image ({
        fieldname: req.file.fieldname,
        originalname: req.file.originalname,
        destination: req.file.destination,
        mimetype: req.file.mimetype,
        filename: req.file.filename,
        path: req.file.path,
        size: req.file.size,
      })
      image.save(function(err) {
        if (err) {
          return res.end("Error uploading file.");
        } else {
          res.json({
            message: 'File uploaded successfully',
            filename: req.file.filename, // + fileExtension,
            url: `${process.env.PWD}/images/${req.file.filename}` //+ fileExtension
          });
          console.log(req.body);
          console.log(req.file);
          }
      })
  });

app.server.listen(config.port);
console.log(`Start on port ${app.server.address().port}`);

export default app;
