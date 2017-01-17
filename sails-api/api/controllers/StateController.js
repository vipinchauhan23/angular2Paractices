/**
 * CategoryController
 *
 * @description :: Server-side logic for managing categories
 * @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
 */

module.exports = {

    // getCountries: function (req, res) {
    //     Country.find().exec(function(err,result){
    //         if (err) return res.serverError(err); 
    //             else return res.json(result);
    //     })    
    // },
    // save topic into  database
	saveState: function (req, res, next) {
            var str = "CALL spSaveState(" + req.body.state_id + "," + req.body.country_id + ",'" + req.body.state_name + "'," + req.body.is_active +")";
            State.query(str, function (err, result) {
                if (err) return res.serverError(err); 
                else return res.json(result[0]);
            });  
    },
// get all topic from  database
    getAllState: function (req, res) {
       var str = "call spGetStates()";
        State.query(str,function(err,result){
            if (err) return res.serverError(err); 
                else return res.json(result[0]);
        })    
    },
    // get topic by topic_id from  database
    getStateById: function (req, res) {
        var stateId = req.param('state_id');
        var str = "call spGetStateById("+ stateId +")";
        State.query(str,function(err,result){
            if (err) return res.serverError(err); 
                else return res.json(result[0]);
        })    
    },
    // get topic by topic_id from  database
     deleteState: function (req, res) {
        var stateId = req.param('state_id');
         var str = "delete from  state where state_id ="+ stateId;
        State.query(str, function (err, result){
            if (err) return res.serverError(err); 
                else return res.json(result);
        });    
    }    
};

