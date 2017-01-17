/**
 * CategoryController
 *
 * @description :: Server-side logic for managing categories
 * @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
 */
var builder = require('xmlbuilder');
module.exports = {

    // get all topic from  database
    // getEmployees: function (req, res) {
    //     var str = "CALL spGetEmployees()";
    //     Employee.query( str, function (err, result) {
    //         if (err) return res.serverError(err);
    //         else
    //             return res.json(result[0]);
    //     });
    // },
    getEmployees: function (req, res) {
        Employee.find().exec(function(err,result){
            if (err) return res.serverError(err); 
                else return res.json(result);
        })    
    },

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

    saveEmployeeRecord: function (req, res, next) {
        var j = 0;
        var str = "delete from employeerecord where employee_id =" + req.body.employee_id;
        Employee.query(str, function (err, employeeDetails) {
            if (err) {
                return res.serverError(err);
            }
            else {
                req.body.selectedQualifications.forEach(function (element) {
                    var str = "call spSaveEmployeeDetails( 0,"
                        + req.body.employee_id + "," + element + ")";
                    Employee.query(str, function (err, result) {
                        if (err) {
                            return res.serverError(err);
                        } else {
                            if (j == req.body.selectedQualifications.length - 1) {
                                return res.json(result[0]);
                            }
                            j++;
                        }
                    })
                })
            }
        })
    },


    // get all topic from  database
    getEmployeeRecords: function (req, res) {
        var str = "call spGetEmployeeRecords()";
        Employee.query(str, function (err, result) {
            if (err) return res.serverError(err);
            else return res.json(result[0]);
        })
    },
    // get topic by topic_id from  database
    getEmployeeRecordByID: function (req, res) {
        var employeeId = req.param('employee_id');
        var str = "select * from employee where employee_id =" + employeeId;
        Employee.query(str, function (err, result) {
            if (err) return res.serverError(err);
            else {
                var str = "select * from employeerecord where employee_id =" + employeeId;
                Employee.query(str, function (err, employeeRecords) {
                    if (err) return res.serverError(err);
                    else {
                        result[0].selectedQualifications = [];
                        employeeRecords.map(function (item) {
                            result[0].selectedQualifications.push(item.qualification_id);
                        });
                        return res.json(result[0]);
                    }
                });
            }
        })
    },

    deleteEmployeeRecord: function (req, res) {
        var employee_id = req.param('employee_id');
        var str = "delete from employeerecord where employee_id =" + employee_id;
        Employee.query(str, function (err, result) {
            if (err) return res.serverError(err);
            return res.json(result);
        });
    }
};

