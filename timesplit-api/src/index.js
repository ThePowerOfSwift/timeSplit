import http from 'http';
import express from 'express';
import bodyParser from 'body-parser';
import mongoose from 'mongoose';
import path from 'path';
import config from './config';
import routes from './routes';
import passport from 'passport';
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

// URL : http://localhost:3005/v1/images
// To get all the images/files stored in MongoDB
app.get('/images', function(req, res) {
  routes.getImages(function(err, genres) {
    if (err) {
      res.send(err);
    }
    res.json(genres);
  });
});

// URL : http://localhost:3005/images/(give you a collection ID)
// To get the single image/file using id from the MongoDB
app.get('/images/:id', function(req, res) {
  //calling the function from index.js class using the routes object
  routes.getImageById(req.params.id, function(err, genres) {
    if (err) {
      res.send(err);
    }
    res.send(genres.path);
  });
});

app.server.listen(config.port);
console.log(`Start on port ${app.server.address().port}`);

export default app;
