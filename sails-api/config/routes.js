/**
 * Route Mappings
 * (sails.config.routes)
 *
 * Your routes map URLs to views and controllers.
 *
 * If Sails receives a URL that doesn't match any of the routes below,
 * it will check for matching files (images, scripts, stylesheets, etc.)
 * in your assets directory.  e.g. `http://localhost:1337/images/foo.jpg`
 * might match an image file: `/assets/images/foo.jpg`
 *
 * Finally, if those don't match either, the default 404 handler is triggered.
 * See `api/responses/notFound.js` to adjust your app's 404 logic.
 *
 * Note: Sails doesn't ACTUALLY serve stuff from `assets`-- the default Gruntfile in Sails copies
 * flat files from `assets` to `.tmp/public`.  This allows you to do things like compile LESS or
 * CoffeeScript for the front-end.
 *
 * For more information on configuring custom routes, check out:
 * http://sailsjs.org/#!/documentation/concepts/Routes/RouteTargetSyntax.html
 */

module.exports.routes = {

  /***************************************************************************
  *                                                                          *
  * Make the view located at `views/homepage.ejs` (or `views/homepage.jade`, *
  * etc. depending on your default view engine) your home page.              *
  *                                                                          *
  * (Alternatively, remove this and add an `index.html` file in your         *
  * `assets` directory)                                                      *
  *                                                                          *
  ***************************************************************************/

  '/': {
    view: 'homepage'
  },

  /***************************************************************************
  *                                                                          *
  * Custom routes here...                                                    *
  *                                                                          *
  * If a request to a URL doesn't match any of the custom routes above, it   *
  * is matched against Sails route blueprints. See `config/blueprints.js`    *
  * for configuration options and examples.                                  *
  *                                                                          *
  ***************************************************************************/
  'get /getItems': 'ProductController.getItems',
  'get /getProducts': 'ProductController.getProducts',
  'get /getProductByID/:product_id': 'ProductController.getProductByID',
  'delete /deleteProduct/:product_id': 'ProductController.deleteProduct',
  'post /saveProduct': 'ProductController.saveProduct',


 'get /getTravels': 'TravelController.getTravels',
  'get /getTravelById/:traval_id': 'TravelController.getTravelById',
  'delete /deleteTravel/:traval_id': 'TravelController.deleteTravel',
  'post /saveTravel': 'TravelController.saveTravel',

  'get /getEmployees': 'EmployeeRecordController.getEmployees',
  'get /getEmployeeRecords': 'EmployeeRecordController.getEmployeeRecords',
  'get /getEmployeeRecordByID/:employee_id': 'EmployeeRecordController.getEmployeeRecordByID',
  'delete /deleteEmployeeRecord/:employee_id': 'EmployeeRecordController.deleteEmployeeRecord',
  'post /saveEmployeeRecord': 'EmployeeRecordController.saveEmployeeRecord',


  'get /getCountries': 'CountryController.getAllCountry',
  'get /getCountry/:country_id': 'CountryController.getCountry',
  'delete /deleteCountry/:country_id': 'CountryController.removeCountry',
  'post /saveCountry': 'CountryController.saveCountry',

  'get /getStates': 'StateController.getAllState',
//  'get /getCountries': 'StateController.getCountries',
  'get /getState/:state_id': 'StateController.getStateById',
  'delete /deleteState/:state_id': 'StateController.deleteState',
  'post /saveState': 'StateController.saveState',

  'get /getCities': 'CityController.getAllCity',
//  'get /getStates': 'CityController.getStates',
  'get /getCity/:city_id': 'CityController.getCityById',
  'delete /deleteCity/:city_id': 'CityController.deleteCity',
  'post /saveCity': 'CityController.saveCity',

  'get /getQualifications': 'QualificationController.getQualifications',
  'get /getQualification/:qualification_id': 'QualificationController.getQualification',
  'delete /deleteQualification/:qualification_id': 'QualificationController.removeQualification',
  'post /saveQualification': 'QualificationController.saveQualification',

  'get /getGroups': 'BusinessPartnerMasterController.getGroups',  
  'post /saveBusinessPartnerMaster': 'BusinessPartnerMasterController.saveBusinessPartnerMaster',
  'get /getBusinessPartners': 'BusinessPartnerMasterController.getBusinessPartners',
  'get /getBusinessPartnerById/:businesspartnermaster_id': 'BusinessPartnerMasterController.getBusinessPartnerById',
  'delete /deleteBusinessPartners/:businesspartnermaster_id': 'BusinessPartnerMasterController.deleteBusinessPartners',
  

  'get /getTopics': 'TopicController.getAllTopic',
  'get /getTopic/:topic_id': 'TopicController.getTopic',
  'delete /deleteTopic/:topic_id': 'TopicController.removeTopic',
  'post /savetopic': 'TopicController.saveTopic',


  'get /getOnlineTest/:online_test_id': 'OnlineTestController.getOnlineTest',
  'post /onlineTest': 'OnlineTestController.saveOnlineTest',
  'get /getOnlineTests': 'OnlineTestController.getOnlineTests',
  'get /deletetest/:online_test_id': 'OnlineTestController.removeTest',


  'post /company': 'CompanyController.saveCompany',
  'get /getCompanies': 'CompanyController.getAllCompanies',
  'get /getCompanyById/:company_id': 'CompanyController.getCompanyByID',

  'get /questionSet': 'QuestionSetController.getQuestionSets',
  'get /questionSet/:question_set_id': 'QuestionSetController.getQuestionSet',
  'get /questionSets/:user_id': 'QuestionSetController.getQuestionSetsbyUser',
  'post /saveQuestionSet': 'QuestionSetController.saveQuestionSet',

  'post /question': 'QuestionController.saveQuestion',
  'get /questions': 'QuestionController.getQuestions',
  'get /question/:topic_id': 'QuestionController.getQuestionsByTopic',
  'post /getQuestionsbyUser': 'QuestionController.getQuestionsbyUser',
  'get /questionbyid/:question_id': 'QuestionController.getQuestionByQuestionID',
  'get /questionStateInfo': 'QuestionController.getQuestionState',

  'get /questionOptions/:question_id': 'QuestionOptionController.getQuestionOptions',
  'get /optionSeries': 'QuestionOptionController.getOptionSeries',

  'post /file/upload': 'FileController.upload',

  'get /users': 'UserController.getUser',
  'get /userEmail/:email_id': 'UserController.searchUserByEmail',
  'get /user/:user_id': 'UserController.getUserById',
  'post /user': 'UserController.saveUser',

  'get /email': 'EmailController.email',
  'post /login': 'AuthController.login',

  'post /onlineTestTimeOut': 'AnswerController.testTimeOut',
  'post /saveAnswer': 'AnswerController.saveAns',
  'get /testResult/:testUserId': 'AnswerController.getTestResult'

};
