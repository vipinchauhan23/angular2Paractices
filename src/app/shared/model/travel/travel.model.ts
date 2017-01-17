import { TravelDetails } from '../../../components/shared/travel-details/travel-details.model';

export class Travel {
  traval_id: number = 0;
  employee_name: string = '';
  advance: string = '';
  travel_date: string = '';
  is_active: number = 0;
  travelDetails: Array<TravelDetails>;
  constructor() {
      this.travelDetails = new Array<TravelDetails>();
  }
}
