
/********************************************************************************
 *                                                                              *
 * email Service                                                                *
 *                                                                              *
 *******************************************************************************/

var nodemailer = require("nodemailer");

module.exports = {

    /**
     * create reusable transport method (opens pool of SMTP connections)
     * Possible SMTP options are the following:
     * 
     * service - an optional well known service identifier ("Gmail", "Hotmail" etc., see Well known Services for a list of supported services) to auto-configure host, port and secure connection settings
     * host - hostname of the SMTP server (defaults to "localhost", not needed with service)
     * port - port of the SMTP server (defaults to 25, not needed with service)
     * secureConnection - use SSL (default is false, not needed with service). If you're using port 587 then keep secureConnection false, since the connection is started in insecure plain text mode and only later upgraded with STARTTLS
     * name - the name of the client server (defaults to machine name)
     * auth - authentication object as {user:"...", pass:"..."} or {XOAuth2: {xoauth2_options}} or {XOAuthToken: "base64data"}
     * ignoreTLS - ignore server support for STARTTLS (defaults to false)
     * debug - output client and server messages to console
     * maxConnections - how many connections to keep in the pool (defaults to 5)
     * maxMessages - limit the count of messages to send through a single connection (no limit by default)
     */
    createTransport:function(obj){
        return nodemailer.createTransport("SMTP", {
            // host: obj.host, // hostname
            // secureConnection: true, // use SSL
            // port: obj.port, // port for secure SMTP
            // auth: {
            //     user: obj.username,
            //     pass: obj.password
            // }
            host: 'smtp.gmail.com', // hostname
            secureConnection: true, // use SSL
            port: 465, // port for secure SMTP
            auth: {
                user: 'amit.kumar@conqsys.com',
                pass: 'Amit@654'
            }
        });
    },

    /**
     * E-mail message fields
     * The following are the possible fields of an e-mail message:
     *
     * from - The e-mail address of the sender. All e-mail addresses can be plain sender@server.com or formatted Sender Name <sender@server.com>
     * to - Comma separated list or an array of recipients e-mail addresses that will appear on the To: field
     * cc - Comma separated list or an array of recipients e-mail addresses that will appear on the Cc: field
     * bcc - Comma separated list or an array of recipients e-mail addresses that will appear on the Bcc: field
     * replyTo - An e-mail address that will appear on the Reply-To: field
     * inReplyTo - The message-id this message is replying
     * references - Message-id list
     * subject - The subject of the e-mail
     * text - The plaintext version of the message
     * html - The HTML version of the message
     * generateTextFromHTML - if set to true uses HTML to generate plain text body part from the HTML if the text is not defined
     * headers - An object of additional header fields {"X-Key-Name": "key value"} (NB! values are passed as is, you should do your own encoding to 7bit and folding if needed)
     * attachments - An array of attachment objects.
     * alternatives - An array of alternative text contents (in addition to text and html parts)
     * envelope - optional SMTP envelope, if auto generated envelope is not suitable
     * messageId - optional Message-Id value, random value will be generated if not set. Set to false to omit the Message-Id header
     * date - optional Date value, current UTC string will be used if not set
     * encoding - optional transfer encoding for the textual parts (defaults to "quoted-printable")
     * charset - optional output character set for the textual parts (defaults to "utf-8")
     * dsn - An object with methods success, failure and delay. If any of these are set to true, DSN will be used
     * All text fields (e-mail addresses, plaintext body, html body) use UTF-8 as the encoding. Attachments are streamed as binary.
     * 
     * Attachment fields:-
     * Attachment object consists of the following properties:
     * fileName - filename to be reported as the name of the attached file, use of unicode is allowed (except when using Amazon SES which doesn't like it)
     * cid - optional content id for using inline images in HTML message source
     * contents - String or a Buffer contents for the attachment
     * filePath - path to a file or an URL if you want to stream the file instead of including it (better for larger attachments)
     * streamSource - Stream object for arbitrary binary streams if you want to stream the contents (needs to support pause/resume)
     * contentType - optional content type for the attachment, if not set will be derived from the fileName property
     * contentDisposition - optional content disposition type for the attachment, defaults to "attachment"
     */
    createMailOptions: function(obj){
        // return mailOptions = {
        //     from: obj.senderName + " <"+ obj.username +">", // sender address
        //     to: obj.userEmail, // list of receivers
        //     subject: obj.subject, // Subject line
        //     text: "Hello world ✔", // plaintext body
        //     html: "<b>Hello world ✔</b>" // html body
        // }
        return mailOptions = {
            from: "Amit <amit.kumar@conqsys.com>", // sender address
            to: 'amit8774@gmail.com', // list of receivers
            subject: 'Hello', // Subject line
            text: "Hello world ✔", // plaintext body
            html: "<b>Hello world ✔</b>" // html body
        }
    },

    /**
     * send mail with defined transport object
     */
    sendEMail: function(smtpTransport, mailOptions, callback) {
        smtpTransport.sendMail(mailOptions, function(error, response){
            smtpTransport.close(); // shut down the connection pool, no more messages
            if(error) {
                console.log(error);
                callback(error);
            } else {
                console.log("Message sent: " + response.message);
                callback("Message sent: " + response.message);
            }
        })
    },

    sendWelcomeMail: function(obj) {
        sails.hooks.myHook.sendEM(
            'password', 
            {
                recipientName: "Joe",
                senderName: "Sue"
            },
            {
                to: "amit8774@gmail.com",
                subject: "SailsJS email test"
            },
            function(err) {
                console.log(err || 'Mail Sent!');
            }
        )
    }
}
