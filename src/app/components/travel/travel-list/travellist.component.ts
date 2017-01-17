import { Component,OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { Location } from '@angular/common';
import { LocalStorageService } from 'angular-2-local-storage';
import { BaseComponent } from '../../base.component';
import { Travel } from '../../../shared/model/travel/travel.model';
import { TravelService } from '../../../shared/services/travel/travel.service';
import { MessageService } from '../../../shared/services/message/message.service';

@Component({
  moduleId: module.id,
  selector: 'app-travellist',
  templateUrl: 'travellist.component.html',
})
export class TravelListComponent extends BaseComponent implements OnInit {
  private selectedTravel: Travel;
  private model: Travel[] = [];

  constructor(private travelService: TravelService, private messageService: MessageService,
    localStorageService: LocalStorageService,
    router: Router,
    location: Location) {
    super(localStorageService, router, location);
    this.selectedTravel = new Travel();
    this.model = new Array<Travel>();
  }

  ngOnInit(): void {
    if (this.user) {
      this.getTravels();
    }
  }

  showTravel(travelId: number): void {
    this.router.navigate(['/travel', travelId]);
  }

  removeItem(travelId: number): void {
    if (confirm("Are you sure you want to delete?")) {
      this.travelService
        .removeTravel(travelId)
        .then(result => {
          if (result) {
            this.messageService.showMessage('Travel deleted!');
            this.getTravels();
          } else {
            this.messageService.showMessage('Travel not deleted!');
          }
        });
    }
  }


  private getTravels(): void {
    this.travelService
      .getTravels()
      .then(result => {
        if (result) {
          this.model = result;
        }
      });
  }
}
