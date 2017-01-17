/**
 * CategoryController
 *
 * @description :: Server-side logic for managing categories
 * @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
 */

module.exports = {

    // getStates: function (req, res) {
    //     State.find().exec(function(err,result){
    //         if (err) return res.serverError(err); 
    //             else return res.json(result);
    //     })    
    // },
    // save topic into  database
	saveCity: function (req, res, next) {
            var str = "CALL spSaveCity(" + req.body.city_id + "," + req.body.state_id + ",'" + req.body.city_name + "'," + req.body.is_active +")";
            City.query(str, function (err, result) {
                if (err) return res.serverError(err); 
                else return res.json(result[0]);
            });  
    },
// get all topic from  database
    getAllCity: function (req, res) {
       var str = "call spGetCities()";
        City.query(str,function(err,result){
            if (err) return res.serverError(err); 
                else return res.json(result[0]);
        })    
    },
    // get topic by topic_id from  database
    getCityById: function (req, res) {
        var cityId = req.param('city_id');
        var str = "call spGetCityById("+ cityId +")";
        City.query(str,function(err,result){
            if (err) return res.serverError(err); 
                else return res.json(result[0]);
        })    
    },
    // get topic by topic_id from  database
     deleteCity: function (req, res) {
        var cityId = req.param('city_id');
         var str = "delete from  city where city_id ="+ cityId;
        City.query(str, function (err, result){
            if (err) return res.serverError(err); 
                else return res.json(result);
        });    
    }    
};

