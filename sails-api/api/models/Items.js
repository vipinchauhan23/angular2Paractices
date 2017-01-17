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
    items_id:{
      type:"integer",
      unique: true,
      index: true,
      primaryKey: true
    },
   item:{
      type:"string",
      required:true
    },
    item_rate:{
      type:"decimal",
      require:true
    },
  }
};

