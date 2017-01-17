/**
 * Question.js
 *
 * @description :: TODO: You might write a short summary of how this model works and what it represents here.
 * @docs        :: http://sailsjs.org/documentation/concepts/models-and-orm/models
 */

module.exports = {
  autoCreatedAt:false,
  autoUpdatedAt:false,
  autoPK: false,
  attributes: {
    question_id:{
      type:"integer",
      unique: true,
      index: true,
      primaryKey: true
    },
   question_description:{
      type:"string",
      required:true
    },
     company_id:{
      type:"integer",
      required:true
    },
     topic_id:{
      type:"integer",
      required:true
    },
     is_multiple_option:{
      type:"boolean",
      required:true
    },
    answer_explanation:{
      type:"string",
      required:false
    },
    created_by:{
      type:"string"
    },
     updated_by:{ 
      type:"string"
    },
    created_datetime:{
      type:"datetime"
    },  
    updated_datetime:{
      type:"datetime"
    }
  }
};

