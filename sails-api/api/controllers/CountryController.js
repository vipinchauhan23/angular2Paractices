/**
 * CategoryController
 *
 * @description :: Server-side logic for managing categories
 * @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
 */

module.exports = {
    // save topic into  database
	saveCountry: function (req, res, next) {
            var str = "CALL spSaveCountry(" + req.body.country_id + ",'" + req.body.country_name + "','" + req.body.country_code + "'," + req.body.is_active +")";
            Country.query(str, function (err, result) {
                if (err) return res.serverError(err); 
                else return res.json(result[0]);
            });  
    },
// get all topic from  database
    getAllCountry: function (req, res) {
        Country.find().exec(function(err,result){
            if (err) return res.serverError(err); 
                else return res.json(result);
        })    
    },
    // get topic by topic_id from  database
    getCountry: function (req, res) {
        var countryId = req.param('country_id');
        Country.find({ country_id: countryId }).exec(function(err,result){
            if (err) return res.serverError(err); 
                else return res.json(result);
        })    
    },
    // get topic by topic_id from  database
     removeCountry: function (req, res) {
        var countryId = req.param('country_id');
         var str = "delete from  country where country_id ="+ countryId;
        Country.query(str, function (err, result){
            if (err) return res.serverError(err); 
                else return res.json(result);
        });    
    }    
};

