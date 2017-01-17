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
        employee_id: {
            type: "integer",
            unique: true,
            index: true,
            primaryKey: true
        },
        employee_name: {
            type: "string",
        },
        email: {
            type: "string"
        },
        mobile: {
            type: "string"
        },
    }
};

