import { General } from '../../../shared/model/general/general.model';

export class BusinessPartner {
  businesspartnermaster_id: number = 0;
  businesspartnermastertype: number = 0;
  name: string = '';
  foreign_name: string = '';
  group_id: number = 0;
  currency: number = 0;
  federal_tax_id: string = '';
  currency_type: number = 0;
  account_balance: number = 0;
  deliveries: string = '';
  orders: string = '';
  opportunities: number = 0;
  general: General;
}

