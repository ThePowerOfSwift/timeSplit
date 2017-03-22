import mongoose from 'mongoose';
import { Router} from 'express';
import Profile from '../model/profile';
import bodyParser from 'body-parser';
import passport from 'passport';


import { authenticate } from '../middleware/authMiddleware';

export default({ config, db }) => {
  let api = Router();

  return api;
}
