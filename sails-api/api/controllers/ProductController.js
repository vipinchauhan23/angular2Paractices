
module.exports = {
    // get all topic from  database
    // getItems: function (req, res) {
    //     Items.find().exec(function (err, result) {
    //         if (err) return res.serverError(err);
    //         else
    //             return res.json(result);
    //     })
    // },
 // get all topic from  database
    // getEmployeeRecords: function (req, res) {
    //     var str = "call spGetEmployeeRecords()";
    //     Employee.query(str, function (err, result) {
    //         if (err) return res.serverError(err);
    //         else return res.json(result[0]);
    //     })
    // },
    getItems: function (req, res) {
        var str = "CALL spGetItems()";
        Items.query( str, function (err, result) {
            if (err) return res.serverError(err);
            else
                return res.json(result[0]);
        });
    },

    saveProduct: function (req, res, next) {
        if (req.body._item_rate == undefined) {
            req.body._item_rate = req.body.item_rate;
            req.body._quantity = req.body.quantity;
        }
        var str = "CALL spSaveProduct(" + req.body.product_id + ",'" + req.body.product_name + "','" + req.body.product_code + "'," + req.body.item_id + "," + req.body._item_rate + "," + req.body._quantity + ")";
        Product.query(str, function (err, result) {
            if (err) return res.serverError(err);
            else return res.json(result[0]);
        });
    },
    // get all topic from  database
    getProducts: function (req, res) {
        var str = "call spGetProduct()";
        Product.query(str, function (err, result) {
            if (err) return res.serverError(err);
            else return res.json(result[0]);
        })
    },
    // get topic by topic_id from  database
    getProductByID: function (req, res) {
        var productId = req.param('product_id');
        Product.find({ product_id: productId }).exec(function (err, result) {
            if (err) return res.serverError(err);
            else return res.json(result[0]);
        })
    },

    deleteProduct: function (req, res) {
        var productId = req.param('product_id');
        var str = "delete from product where product_id =" + productId;
        Product.query(str, function (err, result) {
            if (err) return res.serverError(err);
            return res.json(result);
        });
    }
};
