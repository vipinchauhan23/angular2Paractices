/**
 * UserController
 *
 * @description :: Server-side logic for managing Users
 * @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
 */

var mailService = require('../services/email');

module.exports = {
    // get users by company_id from  database
    getUser: function (req, res) {
        var str = "CALL spGetUsers(" + req.token.user.company_id + ")";
        User.query(str, function (err, result) {
            if (err) return res.serverError(err);
            else return res.json(result[0]);
        })
    },
// get user by question_id and user_id from  database
    getUserById: function (req, res) {
        var userId = req.param('user_id');
        var str = "CALL spGetUserById(" + userId + "," + req.token.user.company_id + ")";
        User.query(str, function (err, result) {
            if (err) return res.serverError(err);
                else if (result == undefined) return res.json({});
                else {
                    delete result[0][0].user_pwd; 
                    return res.json(result[0][0]);
                }
        })
    },
// search user by email_id from  database
    searchUserByEmail: function (req, res) {
        var emailId = req.param('email_id');
        User.findOne({ user_email: emailId })
            .exec(function(err, result){
                if (err) return res.serverError(err);
                else if (result == undefined) return res.json({});
                else return res.json(result.toJSON());
            })
    },
    // save user into database
    saveUser: function (req, res) {
        var userData = req.body;
        var pwd = User.generateRandomPassword();
        userData.user_pwd = pwd;
        User.beforeCreate(userData, function(err, user){
            if(err){
                return res.json(403, {err: 'error in generating password'});
            }
            var str = "CALL spSaveUser("+ user.user_id + ",'" 
                                        + user.user_name + "','" 
                                        + user.user_email + "','" 
                                        + user.user_mobile_no + "','" 
                                        + user.user_address + "','"
                                        + user.user_pwd + "'," 
                                        + user.is_active + "," 
                                        + user.is_fresher + "," 
                                        + user.user_exp_month + "," 
                                        + user.user_exp_year + "," 
                                        + user.role_id + ",'" 
                                        + req.token.user.user_id + "','" 
                                        + req.token.user.user_id + "')";

            User.query(str, function (err, result) {
                if (err) { 
                    return res.serverError(err);
                } else {
                    var user_id = result[0][0].id;
                    var str = "CALL spSaveCompanyUser(" + req.token.user.company_id + "," + user_id + ")";
                    User.query(str, function (err, result) {
                        if (err) return res.serverError(err);
                        else
                            return res.json(result);
                    })
                }
            });
        })
    },
    // get user by user_id from  database
    removeUser: function (req, res) {
        var userId = req.param('user_id');
        var str = "delete from  user where user_id =" + userId;
        User.query(str, function (err, result) {
            if (err) return res.serverError(err);
            else return res.json(result);
        })
    }
};
