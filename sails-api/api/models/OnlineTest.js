/**
 * Online-test.js
 *
 * @description :: TODO: You might write a short summary of how this model works and what it represents here.
 * @docs        :: http://sailsjs.org/documentation/concepts/models-and-orm/models
 */

module.exports = {
  autoCreatedAt: false,
  autoUpdatedAt: false,
  autoPK: false,
  attributes: {
    online_test_id: {
      type: "integer",
      unique: true,
      index: true,
      primaryKey: true
    },
    company_id:{
      type: "integer",
      required: true
    },
    online_test_title: {
      type: "string",
      required: true
    },
    test_start_date: {
      type: "string",
      required: false
    },
    test_end_date: {
      type: "string",
      required: false
    },
    question_set_id: {
      type: "integer",
      required: true
    },
    test_support_text: {
      type: "string",
      required: false
    },
    test_experience_years: {
      type: "integer",
      required: false
    },
    created_by: {
      type: "string"
    },
    updated_by: {
      type: "string"
    },
    created_datetime: {
      type: "datetime"
    },
    updated_datetime: {
      type: "datetime"
    }
  }
};


