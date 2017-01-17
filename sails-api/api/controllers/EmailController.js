/**
 * EmailController
 *
 * @description :: Server-side logic for managing emails
 * @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
 */

var mailService = require('../services/email');

module.exports = {
	// send EMail to user
     email: function (req, res) {
        var smtpTransport = mailService.createTransport(null);
        var mailOptions = mailService.createMailOptions(null);

        mailService.sendEMail(smtpTransport, mailOptions, function(result){
            return res.json(result)
        });
    }

};

