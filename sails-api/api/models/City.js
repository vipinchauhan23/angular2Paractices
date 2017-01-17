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
        city_id: {
            type: "integer",
            unique: true,
            index: true,
            primaryKey: true
        },
        state_id: {
            type: "integer",
            required: true
        },
        city_name: {
            type: "string"
        },
        is_active: {
            type: "number"
        },
    }
};

