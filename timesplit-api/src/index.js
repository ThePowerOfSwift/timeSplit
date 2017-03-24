import http from 'http';
import express from 'express';
import bodyParser from 'body-parser';
import mongoose from 'mongoose';
import passport from 'passport';
import path from 'path';
import config from './config';
import routes from './routes';
const LocalStrategy = require('passport-local').Strategy;
var fs = require('fs');
var multer = require('multer');

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
  // nameField: 'name',
  usernameField: 'email',
  passwordField: 'password'
},
  Account.authenticate()
));
passport.serializeUser(Account.serializeUser());
passport.deserializeUser(Account.deserializeUser());

// api routes v1
app.use('/v1', routes);
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'pug');
app.get('/', function(req, res) {
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
var upload = multer({
  storage : storage }).single('upl');

app.post('/', function(req, res) {
  upload(req, res, function(err) {
      // let fileExtension = path.extname(req.file.fieldname);
      // let mimetype = req.file.mimetype;
      // const appRoot = process.env.PWD + '/images';
      // var file = appRoot + '/' + req.file.filename + fileExtension;
      // fs.rename(req.file.path, file, (err) => {
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

app.server.listen(config.port);
console.log(`Start on port ${app.server.address().port}`);

export default app;
