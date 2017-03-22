import express from 'express';
import config from '../config';
import middleware from '../middleware';
import initializeDb from '../db';
import effect from '../controller/effect';
import theory from '../controller/theory';
import account from '../controller/account';
import imagefile from '../controller/imagefile';
import profile from '../controller/profile';

let router = express();

// connect to db
initializeDb(db => {

  // internal middleware
router.use(middleware({ config, db }));

  // api routes v1 (/v1)
router.use('/effect', effect({ config, db }));
router.use('/account', account({ config, db }));
router.use('/theory', theory({ config, db }));
router.use('/imagefile', imagefile({ config, db }));
router.use('/profile', profile({ config, db }));
});

export default router;
