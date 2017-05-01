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
import image from './controller/image';
import account from './controller/account';


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
app.get('/v1/images', function(req, res) {
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
  },
});

var upload = multer({ storage : storage });
var type = upload.single('profile');
var Image = require("./model/image")

// NEW TEST
app.post('/images', function(req, res) {
  type(req, res, function(err) {
    if (err) {
      res.end("Error uploading file.");
    }
    // Push new ObjectId
    var userId = req.user.id;
    var userToUpdate = req.params.id;
    var userAccount = { userId: account };
    var image = new Image(req.file);
    Account.findOne(userAccount, function (err, account) {
      if (err) {
        res.status(500).send(err);
      } else {
        account.profileImage = image.ObjectId;
        account.save(function (err, account) {
          if (err) {
            res.status(500).send(err)
          }
        });
      }
    });

    image.save(function (err, imageID_DB) {
      if (err) {
        res.send(err);
      }

    }),
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


// app.post('/images', function(req, res) {
//   type(req, res, function(err) {
//     if (err) {
//       res.end("Error uploading file.");
//     }
//     // Push new ObjectId
//     var userId = req.user.id;
//     var userToUpdate = req.params.id;
//     var userAccount = { userId: account };
//     var image = new Image(req.file);
//     Account.findOne(userAccount, function (err, account) {
//       if (err) {
//         res.status(500).send(err);
//       } else {
//         account.profileImage = image.ObjectId;
//         account.save(function (err, account) {
//           if (err) {
//             res.status(500).send(err)
//           }
//         });
//       }
//     });
//
//     image.save(function (err, imageID_DB) {
//       if (err) {
//         res.send(err);
//       }
//
//     }),
//     res.json({
//         message: 'File uploaded successfully',
//         filename: req.file.filename, // + fileExtension,
//         url: `${process.env.PWD}/images/${req.file.filename}`,
//         id: image._id
//       });
//       console.log(req.body);
//       console.log(req.file);
//       console.log({ id: image._id });
//       res.end("File is uploaded");
//     });

    // app.put('/update/:id', (req, res) => {
    //   var userToUpdate = req.params.id;
    //   Account.findById(userToUpdate, function (err, account) {
    //     if (err) {
    //       res.status(500).send(err);
    //     } else {
    //       account.profileImage = req.image._id;
    //       account.save(function (err, account) {
    //         if (err) {
    //           res.status(500).send(err)
    //         }
    //         var response = {
    //           message: "Profile Image Updated",
    //           id: userToUpdate,
    //           account
    //         };
    //         res.send(response);
    //       });
    //     }
    //   });
    // });

});

app.server.listen(config.port);
console.log(`Start on port ${app.server.address().port}`);

export default app;
