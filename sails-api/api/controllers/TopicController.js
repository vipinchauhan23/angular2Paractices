/**
 * CategoryController
 *
 * @description :: Server-side logic for managing categories
 * @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
 */

module.exports = {
    // save topic into  database
	saveTopic: function (req, res, next) {
            var str = "CALL spSaveTopic(" + req.body.topic_id + ",'" + req.body.topic_title + "','" + req.token.user.company_id + "','" + req.token.user.user_id +"','" +  req.token.user.user_id + "')";
            Topic.query(str, function (err, result) {
                if (err) return res.serverError(err); 
                else return res.json(result);
            });  
    },
// get all topic from  database
    getAllTopic: function (req, res) {
        Topic.find({ company_id: req.token.user.company_id }).exec(function(err,result){
            if (err) return res.serverError(err); 
                else return res.json(result);
        })    
    },
    // get topic by topic_id from  database
    getTopic: function (req, res) {
        var topicId = req.param('topic_id');
        Topic.find({ topic_id: topicId }).exec(function(err,result){
            if (err) return res.serverError(err); 
                else return res.json(result);
        })    
    },
    // get topic by topic_id from  database
     removeTopic: function (req, res) {
        var topicId = req.param('topic_id');
         var str = "delete from  topic where topic_id ="+ topicId;
        Topic.query(str, function (err, result){
            if (err) return res.serverError(err); 
                else return res.json(result);
        })    
    }    
};

