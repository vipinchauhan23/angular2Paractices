/**
 * AnswerController
 *
 * @description :: Server-side logic for managing questions
 * @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
 */

module.exports = {

    saveAns: function (req, res, next) {
        var userId = req.body.question.user_id;
        var qusSetid = req.body.question.question_set_id;
        var testUserId = req.body.onlineTestUserId;
        var selectedOptions = "";
        for (var i = 0; i < req.body.selectedOptions.length; i++) {
            if (i == 0) {
                selectedOptions = req.body.selectedOptions[i].option_id;
            } else {
                selectedOptions = selectedOptions + ',' + req.body.selectedOptions[i].option_id;
            }
        }
        var str = "CALL spSaveAnswer(" + req.body.question.question_id + ",'" + selectedOptions + "'," + req.body.question.online_test_user_id + "," + userId + "," + qusSetid + ")";
        Answer.query(str, function (err, result) {
            if (err) {
                return res.serverError(err);
            }
            else {
                if (req.body.question.remainingQuestion === 0) {
                    var isTestBegin = 0;
                    var str = "call spUpdateOnlineTestUser(" + testUserId + "," + isTestBegin + ")";
                    OnlineTest.query(str, function (err, result) {
                        if (err) {
                            return res.serverError(err);
                        }
                        else {
                            var testUserId = result[0][0];
                            return res.json(testUserId);
                        }
                    });
                }
                else {
                    if (result[0] && result[0].length > 0) {
                        var question = result[0][0];
                        var str = "CALL spGetQuestionOption(" + question.question_id + ")";
                        Question.query(str, function (err, options) {
                            if (err) {
                                return res.serverError(err);
                            }
                            else {
                                question.options = options[0];
                                return res.json(question);
                            }
                        })
                    }
                }
            }
        });
    },

    testTimeOut: function (req, res) {
        var testId = req.body.onlineTestUserId;
        var isTestBegin = 0;
        var str = "call spUpdateOnlineTestUser(" + testId + "," + isTestBegin + ")";
        OnlineTest.query(str, function (err, result) {
            if (err) {
                return res.serverError(err);
            }
            else {
                var testUserId = result[0][0];
                return res.json(testUserId);
            }
        });
    },
    getTestResult: function (req, res) {
        var testId = req.params.testUserId;
        var str = "call spGetTestResult(" + testId + ")";
        OnlineTest.query(str, function (err, result) {
            if (err) {
                return res.serverError(err);
            }
            else {
                var testResult = result[0][0];
                return res.json(testResult);
            }
        });
    },
};

