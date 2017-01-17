/**
 * QuestionSet.js
 *
 * @description :: TODO: You might write a short summary of how this model works and what it represents here.
 * @docs        :: http://sailsjs.org/documentation/concepts/models-and-orm/models
 */

module.exports = {
  autoCreatedAt:false,
  autoUpdatedAt:false,
  autoPK: false,

  attributes: {
    question_set_id:{
      type:"integer",
      unique: true,
      index: true,
      primaryKey: true
    },
    question_set_title:{
      type:"string",
      required:true
    },
    total_time:{
      type:"string"
    },
    company_id:{
      type:"integer",
      required:true
    },
    total_questions:{
      type:"integer"
    },
    is_randomize:{
      type:"boolean"
    },
    option_series_id:{
      type:"integer"
    }
  }
};

