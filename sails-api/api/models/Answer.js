/**
 * Category.js
 *
 * @description :: TODO: You might write a short summary of how this model works and what it represents here.
 * @docs        :: http://sailsjs.org/documentation/concepts/models-and-orm/models
 */

module.exports = {
    autoCreatedAt: false,
    autoUpdatedAt: false,
    autoPK: false,
    attributes: {
        answer_id: {
            type: "integer",
            unique: true,
            index: true,
            primaryKey: true
        },
        question_id: {
            type: "integer",
            required: true
        },
        selected_option: {
            type: "string",
            required: true
        },
        online_test_user_id: {
            type: "integer",
            required: true
        },
        created_datetime: {
            type: "datetime"
        }
    }
};
