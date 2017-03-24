import http from 'http';
import express from 'express';
import bodyParser from 'body-parser';
import mongoose from 'mongoose';
import passport from 'passport';
import path from 'path';
import config from './config';
import routes from './routes';
import fs from 'fs';
const LocalStrategy = require('passport-local').Strategy;

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

var multer = require('multer');
// var fs = require('fs');

app.post('/', multer({ dest: 'uploads/'}).single('upl'),(req, res) => {

  let fileExtension = path.extname(req.file.originalname);
  const appRoot = process.env.PWD + '/images';
  var file = appRoot + '/' + req.file.filename + fileExtension;

  console.log(req.body);
  console.log(req.file);
  res.sendStatus(204).end();
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


app.server.listen(config.port);
console.log(`Start on port ${app.server.address().port}`);

export default app;
