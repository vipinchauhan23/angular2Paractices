/**
 * CategoryController
 *
 * @description :: Server-side logic for managing categories
 * @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
 */
var builder = require('xmlbuilder');
module.exports = {

    // save topic into  database
    // saveTravel: function (req, res, next) {
    //     var travel_date = req.body.travel_date.split("/");
    //     var req.body.travel_date = travel_date[2] + "-" + travel_date[1] + "-" + travel_date[0];
    //     var travelDetailsData = req.body.travelDetails;
    //     if (travelDetailsData.length > 0) {
    //         travelDetailsData.forEach(function (element) {
    //             element.from_date = changeDateFormat(element.from_date);
    //             element.to_date = changeDateFormat(element.to_date);
    //             travelDetailsXML = builder.create('travelDetails')
    //                 .ele('traveldetails_id', element.traveldetails_id).up()
    //                 .ele('from', element.from).up()
    //                 .ele('to', element.to).up()
    //                 .ele('from_date', element.from_date).up()
    //                 .ele('to_date', element.to_date).up()
    //                 .end({ pretty: true });
    //             console.log(travelDetailsXML);
    //         }, this);
    //     }
    //     var str = "CALL spSaveTravel(" + req.body.traval_id + ",'" + req.body.employee_name + "','" + req.body.advance + "','" 
    //     + travel_new_date + "'," + req.body.is_active + ",'" + travelDetailsXML + "')";
    //     Travel.query(str, function (err, result) {
    //         if (err) return res.serverError(err);
    //         else return res.json(result);
    //     });
    // },

    saveTravel: function (req, res, next) {
        var travel_date = req.body.travel_date.split("/");
        req.body.travel_date = travel_date[2] + "-" + travel_date[1] + "-" + travel_date[0];
        var str = "call spSaveTravel(" + req.body.traval_id + ",'" + req.body.employee_name + "','" + req.body.advance + "','" + req.body.travel_date + "'," + req.body.is_active + ")";
        Travel.query(str, function (err, result) {
            if (err) {
                return res.serverError(err);
            } else {
                var traval_id = result[0][0].id;
                req.body.travelDetails.forEach(function (element) {
                    element.from_date = changeDateFormat(element.from_date);
                    element.to_date = changeDateFormat(element.to_date);
                    var str = "call spSaveTravelDetails(" + element.traveldetails_id + ",'" + element.from + "','" + element.to + "','" + element.from_date + "','" + element.to_date + "'," + traval_id + ")";
                    Travel.query(str, function (err, result) {
                        if (err) {
                            return res.serverError(err);
                        } else {
                            //return res.json(result[0]);
                        }
                    })  
                })
                return res.json(result[0]);
            }
        })
    },

    // get all topic from  database
    getTravels: function (req, res) {
        Travel.find().exec(function (err, result) {
            if (err) return res.serverError(err);
            else
                if (result.length > 0) {
                    result.forEach(function (element) {
                        element.travel_date = changeDateFromMySql(element.travel_date);
                    }, this);
                }
            return res.json(result);
        })
    },
    // get topic by topic_id from  database
    getTravelById: function (req, res) {
        var travelId = req.param('traval_id');
        var str = "select * from Travel where traval_id =" + travelId;
        Travel.query(str, function (err, result) {
            if (err) return res.serverError(err);
            else {
                result[0].travel_date = changeDateFromMySql(result[0].travel_date);
                var str = "select * from traveldetails where traval_id =" + travelId;
                Travel.query(str, function (err, travelDetails) {
                    if (err) return res.serverError(err);
                    else
                        if (travelDetails.length > 0) {
                            travelDetails.forEach(function (element) {
                                element.from_date = changeDateFromMySql(element.from_date);
                                element.to_date = changeDateFromMySql(element.to_date);
                            }, this);
                        }
                    result[0].travelDetails = travelDetails;
                    return res.json(result[0]);
                });
            }

        })
    },

      deleteTravel: function (req, res) {
        var travelId = req.param('traval_id');
        var str = "delete from traveldetails where traval_id =" + travelId;
        Travel.query(str, function (err, result) {
            if (err) return res.serverError(err);
            else {
                var str = "delete from Travel where traval_id =" + travelId;
                Travel.query(str, function (err, result) {
                    if (err) return res.serverError(err);
                    else               
                    return res.json(result);
                });
            }
        });
      }
    };
    // get topic by topic_id from  database
//     deleteTravel: function (req, res) {
//         var travelId = req.param('traval_id');
//         var str = "call spDeleteTravel(" + travelId + ")";
//         Travel.query(str, function (err, result) {
//             if (err) return res.serverError(err);
//             else return res.json(result);
//         });
//     }
// };

function changeDateFormat(value) {
    var date = value.split("/");
    return newDate = date[2] + "-" + date[1] + "-" + date[0];
}

function changeDateFromMySql(value) {
    return changedDate = value.getDate() + "/" + value.getMonth() + "/" + value.getFullYear();
}
