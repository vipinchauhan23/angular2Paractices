import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { Location } from '@angular/common';
import { LocalStorageService } from 'angular-2-local-storage';
import { BaseComponent } from '../../base.component';
import { Travel } from '../../../shared/model/travel/travel.model';
import { TravelService } from '../../../shared/services/travel/travel.service';
import { MessageService } from '../../../shared/services/message/message.service';
import { TravelDetails } from '../../../components/shared/travel-details/travel-details.model';

@Component({
  moduleId: module.id,
  selector: 'travel',
  templateUrl: 'travel.component.html'

})
export class TravelComponent extends BaseComponent implements OnInit {
  private model: Travel;
  private travelDetail: TravelDetails;
  private btnText: string;
  private showTravelDetails: boolean;
  private travelId: number;

  constructor(private travelService: TravelService,
    private messageService: MessageService,
    private activatedRoute: ActivatedRoute,
    localStorageService: LocalStorageService,
    router: Router,
    location: Location) {
    super(localStorageService, router, location);
    this.model = new Travel();
    this.showTravelDetails = false;
    // this.travelDetail = new TravelDetails();
  }

  ngOnInit(): void {
    if (this.user) {
      this.activatedRoute.params.subscribe(params => {
        this.travelId = +params['travelId']; // (+) converts string 'id' to a number
      });
      if (this.travelId && this.travelId !== 0) {
        this.getTravelByID(this.travelId);
         this.enableTravelDetails();
        this.btnText = 'Update Travel';
      } else {
        this.btnText = 'Save Travel';
      }
    }
  }

 addTravelDetails(): void {
    this.model.travelDetails.splice(this.model.travelDetails.length, 0, this.travelDetail);
  }
  enableTravelDetails(): void {
    this.travelDetail = new TravelDetails();
    this.model.is_active = +this.model.is_active;
    if (this.model.is_active === 0) {
      if (this.model.travelDetails.length === 0) {
        this.model.travelDetails.splice(this.model.travelDetails.length, 0, this.travelDetail);
      }
      this.showTravelDetails = true;
    } else {
      this.showTravelDetails = false;
    }
  }


  saveTravel(): void {
    // let alertString: String = 'Please select';
    // if (this.model.employee_name == '') {
    //   alertString += '\n BusinessPartner Type \n';
    // }
    // if (this.model.advance === '') {
    //   alertString += 'select Currency \n';
    // }
    // //   alert(alertString);

    // if (this.model.travel_date === '') {
    //   alertString += 'select Currency Type \n';
    // }
    // if (this.model.group_id === undefined || this.model.group_id === 0) {
    //   alertString += 'select Group \n';
    // }
    // if (this.model.name === undefined || this.model.name === '') {
    //   alertString += 'enter Name \n';
    // }

    // if (this.model.foreign_name === undefined || this.model.foreign_name === '') {
    //   alertString += 'enter Foreign Name \n';
    // }

    // if (this.model.deliveries === undefined || this.model.deliveries === '') {
    //   alertString += 'enter Deliveries \n';
    // }
    // if (this.model.orders === undefined || this.model.orders === '') {
    //   alertString += 'enter Orders \n';
    // }
    // if (alertString !== 'Please select') {
    //   this.messageService.showMessage(alertString);
    //   return;
    // }
    this.travelService.saveTravel(this.model).then(result => {
      if (result) {
        this.messageService.showMessage(this.btnText + ' successfully');
        this.router.navigate(['/travel']);
      } else {
        this.messageService.showMessage(this.btnText + ' successfully');
      }
    });
  }

  private getTravelByID(travelId: number): void {
    this.travelService
      .getTravelByID(travelId)
      .then(result => {
        this.model = result;
      });
  }
}
