/**
 * Category.js
 *
 * @description :: TODO: You might write a short summary of how this model works and what it represents here.
 * @docs        :: http://sailsjs.org/documentation/concepts/models-and-orm/models
 */

module.exports = {
  autoCreatedAt:false,
  autoUpdatedAt:false,
  autoPK: false,
  attributes: {
    topic_id:{
      type:"integer",
      unique: true,
      index: true,
      primaryKey: true
    },
   topic_title:{
      type:"string",
      required:true
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

