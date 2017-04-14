//
//  Constants.swift
//  timeSplit
//
//  Created by Cory Billeaud on 3/13/17.
//  Copyright © 2017 Cory. All rights reserved.
//

import Foundation

// Callbacks
// Typealias for callbacks used in the Data Service
typealias callback = (_ success: Bool) -> ()

// Base URL
let BASE_API_URL = "http://localhost:3005/v1"

// EFFECTS
// GET all effects
let GET_ALL_EF_URL = "\(BASE_API_URL)/effect"

// GET all comments for a specific effect
let GET_ALL_EF_Comments = "\(BASE_API_URL)/effect/comments"

// POST add new effect
let POST_ADD_NEW_EFFECT = "\(BASE_API_URL)/effect/add"

// POST add new comment for a specific effect
let POST_ADD_NEW_COMMENT = "\(BASE_API_URL)/effect/comments/add"

// PUT adjust likes for a specific effect
let PUT_ADD_NEW_EF_LIKE = "\(BASE_API_URL)/effect/likes/add"

// POST upload an effect image
let POST_UPLOAD_IMAGE = "\(BASE_API_URL)/upload"


// THEORY
// GET all theories
let GET_ALL_TH_URL = "\(BASE_API_URL)/theory"

// GET all comments for a specific theory
let GET_ALL_TH_Comments = "\(BASE_API_URL)/theory/comments"

// POST add new theory
let POST_ADD_NEW_THEORY = "\(BASE_API_URL)/theory/add"

// POST add new theory comment for a specific theory
let POST_ADD_NEW_THEORY_COMMENT = "\(BASE_API_URL)/theory/comments/add"


// PHOTOS
// POST add photos 
let POST_PHOTO_EFFECTS = "\(BASE_API_URL)/uploads/effects"

// POST add profile photo 
let POST_PROFILE_PHOTO = "\(BASE_API_URL)/uploads/profiles"


// PROFILES
// POST add profile
let POST_PROFILE = "\(BASE_API_URL)/profile/add"

// GET specific profile
let GET_PROFILE = "\(BASE_API_URL)/profile/"

// Boolean auth UserDefaults keys
let DEFAULTS_REGISTERED = "isRegistered"
let DEFAULTS_AUTHENTICATED = "isAuthenticated"

// Auth Email
let DEFAULTS_EMAIL = "email"

// Auth Token
let DEFAULTS_TOKEN = "authToken"

// ACCOUNT ID
//let DEFAULTS_ID = "_id"

// ACCOUNT
// REGISTER URL
let POST_REGISTER_ACCT = "\(BASE_API_URL)/account/register"

let POST_LOGIN_ACCT = "\(BASE_API_URL)/account/login"

// GET ME
let GET_ME = "\(BASE_API_URL)/account/me"

// GET Account by id
let GET_ACCOUNT_BY_ID = "\(BASE_API_URL)/account/profile"

// GET Account by id
let GET_ACCOUNT_ID = "\(BASE_API_URL)/account/profile"



