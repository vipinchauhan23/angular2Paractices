import { Routes, RouterModule } from '@angular/router';

import { CompanyListComponent } from './components/companies/company-list/company-list.component';
import { CompanyComponent } from './components/companies/company/company.component';

import { OnlineTestListComponent } from './components/online-tests/online-test-list/online-test-list.component';
import { OnlineTestComponent } from './components/online-tests/online-test/online-test.component';

import { QuestionListComponent } from './components/questions/question-list/question-list.component';
import { QuestionComponent } from './components/questions/question/question.component';

import { TopicListComponent } from './components/topics/topic-list/topic-list.component';
import { TopicComponent } from './components/topics/topic/topic.component';

import { QuestionSetListComponent } from './components/question-sets/question-set-list/question-set-list.component';
import { QuestionSetComponent } from './components/question-sets/question-set/question-set.component';

import { UserListComponent } from './components/users/user-list/user-list.component';
import { UserComponent } from './components/users/user/user.component';

import { LoginComponent } from './components/login/login.component';

import { TextEditorComponent } from './components/shared/froala/texteditor.component';
import { CheckBoxComponent } from './components/shared/check-box/check-box.component';
import { RadioComponent } from './components/shared/radio/radio.component';

import { CountryListComponent } from './components/countries/country-list/countrylist.component';
import { CountryComponent } from './components/countries/country/country.component';

import { StateListComponent } from './components/states/state-list/statelist.component';
import { StateComponent } from './components/states/state/state.component';

import { CityListComponent } from './components/cities/city-list/citylist.component';
import { CityComponent } from './components/cities/city/city.component';

import { QualificationListComponent } from './components/qualifications/qualification-list/qualificationlist.component';
import { QualificationComponent } from './components/qualifications/qualification/qualification.component';

import { BusinessPartnerComponent } from './components/businessPartner/businessPartnerMaster/businessPartner.component';
import { BusinessPartnerListComponent } from './components/businessPartner/businessPartnerMaster-list/businessPartnerMasterlist.component';

import { TravelComponent } from './components/travel/travel/travel.component';
import {TravelListComponent} from './components/travel/travel-list/travellist.component';

import {EmployeeRecordComponent} from './components/employeeRecord/employee-record/employee-record.component';
import {EmployeeRecordListComponent} from './components/employeeRecord/employee-record-list/employee-record-list.component';

import {ProductComponent} from './components/product/product/product.component';
import {ProductListComponent} from './components/product/product-list/product-list.component';
const appRoutes: Routes = [
  {
    path: '',
    redirectTo: '/questions',
    pathMatch: 'full'
  },
  {
    path: 'questions',
    component: QuestionListComponent
  },
  {
    path: 'question/:questionId',
    component: QuestionComponent
  },
  {
    path: 'questionSets',
    component: QuestionSetListComponent
  },
  {
    path: 'questionSet/:questionSetId',
    component: QuestionSetComponent
  },
  {
    path: 'topics',
    component: TopicListComponent
  },
  {
    path: 'topic/:topicId',
    component: TopicComponent
  },
  {
    path: 'companies',
    component: CompanyListComponent
  },
  {
    path: 'company/:companyId',
    component: CompanyComponent
  },
  {
    path: 'onlineTests',
    component: OnlineTestListComponent
  },
  {
    path: 'onlineTest/:onlineTestId',
    component: OnlineTestComponent
  },
  {
    path: 'users',
    component: UserListComponent
  },
  {
    path: 'user/:userId',
    component: UserComponent
  },
  {
    path: 'login',
    component: LoginComponent
  },
  {
    path: 'country',
    component: CountryListComponent
  },
   {
    path: 'country/:countryId',
    component: CountryComponent
  },
   {
    path: 'state',
    component: StateListComponent
  },
   {
    path: 'state/:stateId',
    component: StateComponent
  },
    {
    path: 'city',
    component: CityListComponent
  },
   {
    path: 'city/:cityId',
    component: CityComponent
  },
   {
    path: 'qualification',
    component: QualificationListComponent
  },
   {
    path: 'qualification/:qualificationId',
    component: QualificationComponent
  },
   {
    path: 'bp',
    component: BusinessPartnerListComponent
  },
{
    path: 'bp/:bpId',
    component: BusinessPartnerComponent
  },
  {
    path: 'travel',
    component: TravelListComponent
  },
  {
    path: 'travel/:travelId',
    component: TravelComponent
  },
  {
    path: 'erecord',
    component: EmployeeRecordListComponent
  },
   {
    path: 'erecord/:erecordId',
    component: EmployeeRecordComponent
  },
   {
    path: 'product',
    component: ProductListComponent
  },
   {
    path: 'product/:productId',
    component: ProductComponent
  },
];

export const routing = RouterModule.forRoot(appRoutes);

export const routedComponents = [
  QuestionListComponent, QuestionComponent,
  QuestionSetListComponent, QuestionSetComponent,
  TopicListComponent, TopicComponent,
  CompanyListComponent, CompanyComponent,
  UserListComponent, UserComponent,
  OnlineTestComponent, OnlineTestListComponent,
  LoginComponent,
  TextEditorComponent, CheckBoxComponent, RadioComponent,
  CountryComponent, CountryListComponent,
  StateComponent, StateListComponent,
  CityComponent, CityListComponent,
  QualificationListComponent, QualificationComponent,
  BusinessPartnerComponent, BusinessPartnerListComponent,
  TravelListComponent, TravelComponent,
  EmployeeRecordComponent, EmployeeRecordListComponent,
  ProductComponent, ProductListComponent,
];

