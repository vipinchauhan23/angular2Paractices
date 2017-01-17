import {Http} from '@angular/http';
import {Injectable} from '@angular/core';
import { ApiUrl } from '../../api-url.component';
import { BusinessPartner } from '../../../shared/model/businesspartner/businessPartner.model';
import { Group } from '../../../shared/model/group/group.model';

@Injectable()
export class BusinessPartnerService {
  constructor(private http: Http) {

  }

  saveBusinessPartnerMaster(businessPartner: BusinessPartner): Promise<BusinessPartner[]> {
    return this
      .http
      .post(ApiUrl.baseUrl + 'saveBusinessPartnerMaster', JSON.stringify(businessPartner))
      .toPromise()
      .then(response => response.json() as BusinessPartner[])
      .catch(this.handleError);
  }

   getGroups(): Promise<Group[]> {
    return this
      .http
      .get(ApiUrl.baseUrl + 'getGroups')
      .toPromise()
      .then(response => response.json() as Group[])
      .catch(this.handleError);
  }
getBusinessPartners(): Promise<BusinessPartner[]> {
    return this
      .http
      .get(ApiUrl.baseUrl + 'getBusinessPartners')
      .toPromise()
      .then(response => response.json() as BusinessPartner[])
      .catch(this.handleError);
  }

  getBusinessPartnerById(businesspartnermaster_id: number): Promise<BusinessPartner> {
    return this
      .http
      .get(ApiUrl.baseUrl + 'getBusinessPartnerById/' + businesspartnermaster_id)
      .toPromise()
      .then(response => response.json() as BusinessPartner)
      .catch(this.handleError);
  }

  deleteBusinessPartners(businesspartnermaster_id: number): Promise<BusinessPartner[]> {
    return this
      .http
      .delete(ApiUrl.baseUrl + 'deleteBusinessPartners/' + businesspartnermaster_id)
      .toPromise()
      .then(response => response.json() as BusinessPartner[])
      .catch(this.handleError);
  }

  private handleError(error: any): Promise<any> {
    console.error('An error occurred', error);
    return Promise.reject(error.message || error);
  }
}
