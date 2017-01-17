//var passport = require('passport');

var jwToken = require('../services/jwToken');

module.exports = {

    _config: {
        actions: false,
        shortcuts: false,
        rest: false
    },
// user login method 
    login: function(req, res) {

        var email = req.body.username;
        var password = req.body.password;

        if (!email || !password) {
           return res.json(401, {err: 'email and password required'});
        }

        User.findOne({user_email: email}, function (err, user) {
            if (!user) {
                return res.json(401, {err: 'invalid email or password'});
            }
       // CALL comparePassword for user login     
            User.comparePassword(password, user, function (err, valid) {
                if (err) {
                    return res.forbidden(err);
                    //return res.json(403, {err: 'forbidden'});
                }
                if (!valid) {
                    return res.json(401, {err: 'invalid email or password'});
                } else {
                    var str = "CALL spGetLoginDetail(" + user.user_id + ")";
                    User.query(str, function (err, result) {
                        if(err) {
                            return res.forbidden(err);
                        } else {
                            var userData = result[0][0];
                            var token = jwToken.issue({user : userData })
                            res.json({
                                user: userData,
                                token: token
                            });
                        }
                    })
                }
            })
        })
    },
// user logout method
    logout: function(req, res) {
        req.logout();
        res.redirect('/');
    }
};