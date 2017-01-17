
module.exports = {

    saveEmployeeTransaction: function (req, res, next) {
        var transaction_date = req.body.date.split("/");
        req.body.date = transaction_date[2] + "-" + transaction_date[1] + "-" + transaction_date[0];

        EmployeeTransaction.find().where({ employee_id: req.body.employee_id }, { date: req.body.date }).exec(function (err, result) {
            if (err) return res.serverError(err);
            else {
                if (result.length > 3) {
                    return res.json(result);
                }
                else {
                    var str = "CALL spSaveEmployeeTransaction(" + req.body.employee_transaction_id + "," + req.body.type + "," + req.body.employee_id + ",'" + req.body.amount + "','" + req.body.date + "')";
                    EmployeeTransaction.query(str, function (err, result) {
                        if (err) return res.serverError(err);
                        else return res.json(result[0]);
                    });
                }
            }
        });
    },
    // get all topic from  database
    getEmployeeTransactions: function (req, res) {
        var str = "call spGetEmployeeTransactions()";
        EmployeeTransaction.query(str, function (err, result) {
            if (err) return res.serverError(err);
            else
                if (result[0].length > 0) {
                    result[0].forEach(function (element) {
                        element.date = changeDateFromMySql(element.date);
                    }, this);
                }
            return res.json(result[0]);
        });
    },
    // get topic by topic_id from  database
    getEmployeeTransactionByID: function (req, res) {
        var employeeTransactionId = req.param('employee_transaction_id');
        EmployeeTransaction.find({ employee_transaction_id: employeeTransactionId }).exec(function (err, result) {
            if (err) return res.serverError(err);
            else
                result[0].date = changeDateFromMySql(result[0].date);
            return res.json(result[0]);
        })
    },

    // checkDayTransaction: function (req, res) {
    //     var employeeTransactionId = req.param('employee_transaction_id');
    //     var date = req.param('date');
    //     EmployeeTransaction.find().where({ employee_transaction_id: employeeTransactionId }, { date: date }).exec(function (err, result) {
    //         if (err) return res.serverError(err);
    //         else
    //             if (result.length > 0) {
    //                 result.forEach(function (element) {
    //                     element.date = changeDateFromMySql(element.date);
    //                 }, this);
    //             }
    //         return res.json(result[0]);
    //     })
    // },
    deleteEmployeeTransaction: function (req, res) {
        var employeeTransactionId = req.param('employee_transaction_id');
        var str = "delete from employeetransaction where employee_transaction_id =" + employeeTransactionId;
        EmployeeTransaction.query(str, function (err, result) {
            if (err) return res.serverError(err);
            return res.json(result);
        });
    }
};
function changeDateFormat(value) {
    var date = value.split("/");
    return newDate = date[2] + "-" + date[1] + "-" + date[0];
}

function changeDateFromMySql(value) {
    return changedDate = value.getDate() + "/" + value.getMonth() + "/" + value.getFullYear();
}
