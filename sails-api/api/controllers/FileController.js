/**
 * FileController
 *
 * @description :: Server-side logic for managing files
 * @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
 */

module.exports = {
    //    upload file and image
    upload: function (req, res) {
        if (req.method === 'GET')
            return res.json({ 'status': 'GET not allowed' });
        //	Call to /upload via GET is error

        var uploadFile = req.file('file');
        console.log(uploadFile);

        uploadFile.upload({ dirname: require('path').normalize(__dirname + '/../../.tmp/public/images') }, function onUploadComplete(err, files) {
            //	Files will be uploaded to .tmp/uploads

            if (err) return res.serverError(err);
            //	IF ERROR Return and send 500 error with error
            var filepath = files[0].fd.split("\\");
            var fs = require('fs');

            fs.createReadStream(files[0].fd).pipe(fs.createWriteStream(__dirname + '/../../assets/images/' + filepath[filepath.length - 1]));
            console.log(files);
            res.json({ link: "http://localhost:1337/images/" + filepath[filepath.length - 1] });
        });
    }
};

