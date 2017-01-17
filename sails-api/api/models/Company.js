/**
 * Company.js
 *
 * @description :: TODO: You might write a short summary of how this model works and what it represents here.
 * @docs        :: http://sailsjs.org/documentation/concepts/models-and-orm/models
 */

module.exports = {
 autoCreatedAt:false,
  autoUpdatedAt:false,
  autoPK: false,
  attributes: {
company_id:{
    type:"integer",
      unique: true,
      index: true,
      primaryKey: true
},
company_title:{
   type:"string",
   required:true
},
company_url:{
  type:"string",
   required:false
},
company_address:{
   type:"string",
   required:true
},
company_phone:{
    type:"string",
   required:true
},
company_email:{
  type:"string",
   required:true
},
company_hr_phone:{
  type:"string",
   required:true
},
company_hr_emailid:{
  type:"string",
   required:false
},
smtp_host:{
  type:"string",
   required:false}, 
smtp_port:{
    type:"integer",
      required:false
}, 
smtp_username:{
  type:"string",
   required:false
}, 
smtp_password :{
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
