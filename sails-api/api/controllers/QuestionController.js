/**
 * QuestionController
 *
 * @description :: Server-side logic for managing questions
 * @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
 */

module.exports = {
    // save Question from  database 
    saveQuestion: function (req, res, next) {
        var companyId = req.token.user.company_id;
        var createdBy = req.token.user.user_id;
        var str = "CALL spSaveQuestion(" + req.body.question_id + ",'" + req.body.question_description + "'," + req.body.topic_id + "," + req.body.is_multiple_option + ",'" + req.body.answer_explanation + "'," + companyId + ",'" + createdBy + "','" + createdBy + "')";
        Question.query(str, function (err, result) {
            if (err) return res.serverError(err);
            else {
                if (req.body.options.length > 0) {
                    req.body.options.forEach(function (option, index) {
                        var str = "CALL spSaveQuestionOption(" + option.option_id + ",'" + option.description + "'," + option.is_correct + "," + result[0][0].id + ")";
                        Question.query(str, function (err, result) {
                            if (err) return res.serverError(err);
                            if (index === req.body.options.length - 1)
                                return res.json("Save success");
                        })
                    });
                }
                else {
                    return res.json("Save success");
                }
            }
        });
    },
    // get Questions by company_id from  database 
    getQuestions: function (req, res) {
        Question.find({ company_id: req.token.user.company_id }).exec(function (err, result) {
            if (err) return res.serverError(err);
            else {
                return res.json(result);
            }
        })
    },
    // get Questions by topic_id from  database 
    getQuestionsByTopic: function (req, res) {
        var topicId = req.param('topic_id');
        var str = "CALL spGetQuestionsByTopic(" + topicId + ")";
        Question.query(str, function (err, result) {
            if (err) return res.serverError(err);
            else {
                return res.json(result[0]);
            }
        })
    },

    // get QuestionSets by user_id and question_set_id from  database
    getQuestionsbyUser: function (req, res) {
        var testUserId = req.body.onlineTestUserId;
        var userId = req.body.userid;
        var qusSetid = req.body.questionSetid;
        var str = "CALL spGetTestQuestion(" + testUserId + "," + userId + "," + qusSetid + ")";
        Question.query(str, function (err, result) {
            if (err) {
                return res.serverError(err);
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
                            if (options[0].length > 0)
                                var isTestBegin = 1;
                            var str = "call spUpdateOnlineTestUser(" + testUserId + "," + isTestBegin + ")";
                            OnlineTest.query(str, function (err, result) {
                                if (err) {
                                    return res.serverError(err);
                                }
                                else {
                                    question.id = result[0][0];
                                    return res.json(question);
                                }
                            });
                        }
                    })
                }
                else {
                    return res.json(result[0][0]);
                }
            }
        })
    },

    // get Question by question_id from  database 
    getQuestionByQuestionID: function (req, res) {
        var question_id = req.param('question_id');
        if (question_id == 0) return res.json([]);
        Question.findOne({ question_id: question_id }).exec(function (err, result) {
            if (err) return res.serverError(err);
            else if (result) {
                QuestionOption.find({ question_id: question_id })
                    .exec(function (err, options) {
                        if (err) return res.serverError(err);
                        else {
                            result.options = options;
                            return res.json(result);
                        }
                    })
            }
            else {
                return res.json(result);
            }
        })
    },

    // get question Stateinfo
    getQuestionState: function (req, res) {
        var str = "CALL spGetQuestionStateInfo(" + req.token.user.company_id + ")";
        Question.query(str, function (err, result) {
            if (err) return res.serverError(err);
            else {
                return res.json(result[0]);
            }
        })
    },
    // delete Question by question_id from  database 
    deleteQuestion: function (req, res) {
        var question_id = req.param('question_id');
        var str = "delete from  question where question_id =" + question_id;
        Topic.query(str, function (err, result) {
            if (err) return res.serverError(err);
            else return res.json(result);
        })
    }

};

