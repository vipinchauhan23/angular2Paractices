/**
 * CategoryController
 *
 * @description :: Server-side logic for managing categories
 * @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
 */

module.exports = {
    // save topic into  database
	saveQualification: function (req, res, next) {
            var str = "CALL spSaveQualification(" + req.body.qualification_id + ",'" + req.body.qualification_name + "'," + req.body.is_active +")";
            Qualification.query(str, function (err, result) {
                if (err) return res.serverError(err); 
                else return res.json(result[0]);
            });  
    },
// get all topic from  database
    getQualifications: function (req, res) {
        Qualification.find().exec(function(err,result){
            if (err) return res.serverError(err); 
                else return res.json(result);
        })    
    },
    // get topic by topic_id from  database
    getQualification: function (req, res) {
        var qualificationId = req.param('qualification_id');
        Qualification.find({ qualification_id: qualificationId }).exec(function(err,result){
            if (err) return res.serverError(err); 
                else return res.json(result);
        })    
    },
    // get topic by topic_id from  database
     removeQualification: function (req, res) {
        var qualificationId = req.param('qualification_id');
         var str = "delete from  qualification where qualification_id ="+ qualificationId;
        Qualification.query(str, function (err, result){
            if (err) return res.serverError(err); 
                else return res.json(result);
        });    
    }    
};

