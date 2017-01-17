/**
 * 
 *
 * @description :: TODO: You might write a short summary of how this model works and what it represents here.
 * @docs        :: http://sailsjs.org/documentation/concepts/models-and-orm/models
 */

module.exports = {
    autoCreatedAt: false,
    autoUpdatedAt: false,
    autoPK: false,
    attributes: {
        businesspartnermaster_id: {
            type: "integer",
            unique: true,
            index: true,
            primaryKey: true
        },
        businesspartnermastertype: {
            type: "integer",
            required: true
        },
        name: {
            type: "string",
            required: true
        },
        foreign_name: {
            type: "string"
        },
        group_id: {
            type: "integer",
            required: true
        },
        currency: {
            type: 'integer'
        },
        federal_tax_id: {
            type: 'string'
        },
        currency_type: {
            type: 'integer'
        },
        account_balance: {
            type: 'decimal'
        },
        deliveries: {
            type: 'string'
        },
        orders:{
               type: 'string'
        },
        opportunities:{
             type: 'integer'
        }
    }
};
