
module.exports = {
    // save Inventry and inventry details according to inventry into database
    saveInventry: function (req, res, next) {
        var str = "call spSaveInventry(" + req.body.inventry_id + "," + req.body.type + ",'" + req.body.name + "','"
            + req.body.address + "','" + req.body.mobile_no + "','" + req.body.tin_no + "','" + req.body.total + "')";
        Inventry.query(str, function (err, inventry) {
            if (err) {
                return res.serverError(err);
            }
            else {
                var inventoryId = inventry[0][0].id;
                var str = "delete from inventry_details where inventry_id =" + inventoryId;
                Inventry.query(str, function (err, result) {
                    if (err) return res.serverError(err);
                    else {
                        var j = 0;
                        req.body.inventryDetails.forEach(function (element) {
                            var str = "call spSaveInventryDetails(" + 0 + ","
                                + inventoryId + "," + element.item_id + ",'" + element.item_rate + "','" + element.quantity + "','" + element.sub_total + "'," + req.body.type + ")";
                            Inventry.query(str, function (err, result) {
                                if (err) {
                                    return res.serverError(err);
                                } else {
                                    if (j == req.body.inventryDetails.length - 1) {
                                        return res.json(result);
                                    }
                                  j++;
                                }
                            })
                        })
                    }
                })
            }
        });
    },
    // get all Inventry from  database
    getInventries: function (req, res) {
        var str = "call spGetInventrys()";
        Inventry.query(str, function (err, result) {
            if (err) return res.serverError(err);
            else return res.json(result[0]);
        })
    },
    // get Inventry by inventry_id from  database

    getInventryByID: function (req, res) {
        var inventryId = req.param('inventry_id');
        var str = "select * from inventry where inventry_id =" + inventryId;
        Inventry.query(str, function (err, result) {
            if (err) return res.serverError(err);
            else {
                var str = "select * from inventry_details where inventry_id =" + inventryId;
                Employee.query(str, function (err, inventryDetails) {
                    if (err) return res.serverError(err);
                    else {
                        result[0].inventryDetails = inventryDetails;
                        return res.json(result[0]);
                    }
                });
            }
        })
    },


    deleteInventry: function (req, res) {
        var inventryId = req.param('inventry_id');
        var str = "call spDeleteInventory(" + inventryId + ")";
        Inventry.query(str, function (err, result) {
            if (err) return res.serverError(err);
            return res.json(result);
        });
    }
};
