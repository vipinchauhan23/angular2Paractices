/**
 * User.js
 *
 * @description :: TODO: You might write a short summary of how this model works and what it represents here.
 * @docs        :: http://sailsjs.org/documentation/concepts/models-and-orm/models
 */

// We don't want to store password with out encryption
var bcrypt = require('bcrypt-nodejs');

module.exports = {
    autoCreatedAt:false,
    autoUpdatedAt:false,
    autoPK: false,

    attributes: {
        user_id :{
            type:"integer",
            required:true,
            unique: true,
            index: true,
            primaryKey: true
        },
        user_name :{
            type:"string",
            required:true
        },
        user_email :{
            type: 'email',
            required: true,
            unique: true
        } ,
        user_mobile_no :{
            type:"string"
        },
        user_address :{
            type:"string"
        },
        user_pwd :{
            type: "string",
            minLength: 6,
            maxLength:30,
            required: true
        }, 
        is_active :{
            type:"boolean",
            required:true    
        },
        is_fresher:{
            type:"boolean"
        } ,
        user_exp_month:{
            type:"integer"
        }, 
        user_exp_year:{
            type:"integer"
        } ,
        role_id :{
            type:"integer"
        } ,
        created_by :{
            type:"string"
        } ,
        updated_by :{
            type:"string"
        }, 
        created_datetime:{
            type:"datetime"
        },
        updated_datetime :{
            type:"datetime"
        },
        toJSON: function() {
            var obj = this.toObject();
            delete obj.user_pwd;
            return obj;
        },
    },

    // Here create encrypt password for user before creating a User
    beforeCreate : function (user, next) {
        bcrypt.genSalt(10, function (err, salt) {
            if(err) { 
                return next(err);
            }
            var progress = function() {};

            bcrypt.hash(user.user_pwd, salt, progress, function (err, hash) {
                if(err) return next(err);
                user.user_pwd = hash;
                next(err, user);
            })
        })
    },

// compare password of user Rndompwd and encrypt password
    comparePassword : function (password, user, callback) {
        bcrypt.compare(password, user.user_pwd, function (err, match) {

        if(err) callback(err);
        if(match) {
            callback(null, true);
        } else {
            callback(err);
        }
        })
    },

// create random password for user 
     generateRandomPassword: function() {
        var text = "";
        var possible = "hijklRSmnABCDEJKLp4MNOPcQTUVWXYZabdeFGHIfgo56qrstxyz0123uvw789";

        for( var i=0; i < 2; i++ )
            text += possible.charAt(Math.floor(Math.random() * possible.length));

        return text;
    }
};
