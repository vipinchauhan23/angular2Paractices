/**
 * QuestionOption.js
 *
 * @description :: TODO: You might write a short summary of how this model works and what it represents here.
 * @docs        :: http://sailsjs.org/documentation/concepts/models-and-orm/models
 */

module.exports = {
 autoCreatedAt:false,
  autoUpdatedAt:false,
  autoPK: false,
  attributes: {
 option_id:{
      type:"integer",
      unique: true,
      index: true,
      primaryKey: true
    },
   description:{
      type:"string",
      required:true
    },
    
     is_correct:{
      type:"boolean",
      required:true
    },
     question_id:{
      type:"integer",
      required:true
    },
  }
};

