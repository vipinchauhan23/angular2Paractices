/**
 * Online-testController
 *
 * @description :: Server-side logic for managing online-tests
 * @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
 */

module.exports = {

    // save Test details into database 
    saveOnlineTest: function (req, res, next) {
        var start_date = req.body.test_start_date.split("/");
        req.body.test_start_date = start_date[2] + "-" + start_date[1] + "-" + start_date[0] + " " + req.body.test_start_time;
        var end_date = req.body.test_end_date.split("/");
        req.body.test_end_date = end_date[2] + "-" + end_date[1] + "-" + end_date[0] + " " + req.body.test_end_time;

        var companyId = req.token.user.company_id;
        var createdBy = req.token.user.user_id;

        var str = "CALL spSaveOnlineTest("  + req.body.online_test_id + "," 
                                            + companyId + ",'" 
                                            + req.body.online_test_title + "','" 
                                            + req.body.test_start_date + "','" 
                                            + req.body.test_end_date + "'," 
                                            + req.body.question_set_id + ",'" 
                                            + req.body.test_support_text + "'," 
                                            + req.body.test_experience_years + ",'" 
                                            + createdBy + "','" 
                                            + createdBy + "')";
        OnlineTest.query(str, function (err, result) {
            if (err) return res.serverError(err);
            else return res.json(result);
        });
    },
    // get Tests from  database  
    getOnlineTests: function (req, res) {
        OnlineTest.find({ company_id: req.token.user.company_id }).exec(function (err, result) {
            if (err) {
                return res.serverError(err);
            }
            else {
                for (var i = 0; i < result.length; i++) {
                    result[i].test_start_date = result[i].test_start_date.toDateString() + " " + result[i].test_start_date.toLocaleTimeString();
                    result[i].test_end_date = result[i].test_end_date.toDateString() + " " + result[i].test_end_date.toLocaleTimeString();
                }
                return res.json(result);
            }
        })
    },
    // get Test from  database 
    getOnlineTest: function (req, res) {
        var online_test_id = req.param('online_test_id');
        var companyId = req.token.user.company_id;
        var str = "call spGetOnlineTest(" + online_test_id + "," + companyId + ")";
        OnlineTest.query(str, function (err, result) {
            if (err) {
                return res.serverError(err);
            }
            else {
                var onlineTest = result[0][0];
                onlineTest.onlineTestUsers = [];
                var str = "call spGetOnlineTestUser(" + online_test_id + "," + companyId + ")";
                OnlineTest.query(str, function (err, result) {
                    if (err) {
                        return res.serverError(err);
                    }
                    else {
                        onlineTest.onlineTestUsers = result[0];
                        return res.json(onlineTest);
                    }
                })
            }
        })
    },
    //  // remove Test from  database 
    removeTest: function (req, res) {
        var online_test_id = req.param('online_test_id');
        var str = "delete from  onlinetest where online_test_id =" + online_test_id;
        OnlineTest.query(str, function (err, result) {
            if (err) return res.serverError(err);
            else return res.json(result);
        })
    }
};

