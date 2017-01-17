/**
 * CategoryController
 *
 * @description :: Server-side logic for managing categories
 * @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
 */
var builder = require('xmlbuilder');
module.exports = {

    getGroups: function (req, res) {
        Group.find().exec(function (err, result) {
            if (err) return res.serverError(err);
            else return res.json(result);
        })
    },
    // save topic into  database
    saveBusinessPartnerMaster: function (req, res, next) {
        var generalTabData = req.body.general;        
        if (generalTabData) {
            generalTabXML = builder.create('general')
                .ele('general_id', generalTabData.general_id).up()
                .ele('telephone', generalTabData.telephone).up()
                .ele('connect_person', generalTabData.connect_person).up()
                .ele('mobile_phone', generalTabData.mobile_phone).up()
                .ele('email', generalTabData.email).up()
                .ele('remark', generalTabData.remark).up()
                .ele('web_site', generalTabData.web_site).up()
                .ele('shipping_id', generalTabData.shipping_id).up()
                .ele('sales_employee_id', generalTabData.sales_employee_id).up()
                .ele('password', generalTabData.password).up()
                .ele('bp_project', generalTabData.bp_project).up()
                .ele('bp_channel_code', generalTabData.bp_channel_code).up()
                .ele('industry_id', generalTabData.industry_id).up()
                .ele('technician', generalTabData.technician).up()
                .ele('alias_name', generalTabData.alias_name).up()
                .ele('language_id', generalTabData.language_id).up()
                .ele('send_marketing_content', generalTabData.send_marketing_content).up()
                .ele('active', generalTabData.active).up()
                .ele('inactive', generalTabData.inactive).up()
                .ele('advance', generalTabData.advance).up()
                .ele('to', generalTabData.to).up()
                .ele('from', generalTabData.from).up()
                .ele('user_remark', generalTabData.user_remark).up()
                .end({ pretty: true });
            console.log(generalTabXML);
        }
        var str = "CALL spSaveBusinessPartnerMaster(" + req.body.businesspartnermaster_id + "," +
            req.body.businesspartnermastertype + ",'" + req.body.name + "','" + req.body.foreign_name + "'," + req.body.group_id + "," +
            req.body.currency + ",'" + req.body.federal_tax_id + "'," + req.body.currency_type + "," + req.body.account_balance + ",'" +
            req.body.deliveries + "','" + req.body.orders + "'," + req.body.opportunities + ",'" + generalTabXML + "')";
        BusinessPartnerMaster.query(str, function (err, result) {
            if (err) return res.serverError(err);
            else return res.json(result);
        });
    },
    // get all topic from  database
    getBusinessPartners: function (req, res) {
        var str = "call spGetBusinessPartners()";
        BusinessPartnerMaster.query(str, function (err, result) {
            if (err) return res.serverError(err);
            else return res.json(result[0]);
        })
    },
    // get topic by topic_id from  database
    getBusinessPartnerById: function (req, res) {
        var businesspartnerId = req.param('businesspartnermaster_id');
        var str = "call spGetBusinessPartnerById(" + businesspartnerId + ")";
        BusinessPartnerMaster.query(str, function (err, result) {
            if (err) return res.serverError(err);
            else {
                businesspartnerId = result[0][0].businesspartnermaster_id;
                var str = "select * from general where businesspartnermaster_id =" + businesspartnerId;
                BusinessPartnerMaster.query(str, function (err, generalData) {
                    if (err) return res.serverError(err);
                    else
                        result[0][1] = generalData[0];
                    return res.json(result[0]);
                });
            }

        })
    },
    // get topic by topic_id from  database
    deleteBusinessPartners: function (req, res) {
        var businesspartnerId = req.param('businesspartnermaster_id');
        var str = "call spDeleteBusinessPartner(" + businesspartnerId + ")";
        BusinessPartnerMaster.query(str, function (err, result) {
            if (err) return res.serverError(err);
            else return res.json(result);
        });
    }

};

