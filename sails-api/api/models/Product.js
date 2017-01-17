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
    product_id:{
      type:"integer",
      unique: true,
      index: true,
      primaryKey: true
    },
    product_name:{
      type:"string",
      required:true
    },
    product_code:{
      type:"string",
      required:true
    },
   item_id:{
      type:"string",
      required:true
    },
    item_rate:{
      type:"decimal",
      require:true
    },
    quantity:{
      type:"decimal",
      require:true
    },
  }
};

