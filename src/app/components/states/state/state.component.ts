import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { Location } from '@angular/common';
import { LocalStorageService } from 'angular-2-local-storage';
import { BaseComponent } from '../../base.component';
import { Country } from '../../../shared/model/country/country.model';
import { State } from '../../../shared/model/state/state.model';
import { StateService } from '../../../shared/services/state/state.service';
import { MessageService } from '../../../shared/services/message/message.service';

@Component({
  moduleId: module.id,
  selector: 'app-state',
  templateUrl: 'state.component.html'
})
export class StateComponent extends BaseComponent implements OnInit {
  private model: State;
  private btnText: string;
  private stateId: number;
  private countries: Country[] = [];

  constructor(private stateService: StateService, private messageService: MessageService,
    private activatedRoute: ActivatedRoute,
    localStorageService: LocalStorageService,
    router: Router,
    location: Location) {
    super(localStorageService, router, location);
    this.model = new State();
    this.countries = new Array<Country>();
  }

  ngOnInit(): void {
    if (this.user) {
      this.activatedRoute.params.subscribe(params => {
        this.stateId = +params['stateId']; // (+) converts string 'id' to a number
      });
      this.getCountries();
    }
  }

  saveState(): void {
  if (this.model.country_id == 0 || this.model.country_id == undefined) {
      this.messageService.showMessage('Please select country');
      return;
    }
    if (this.model.state_name == '' || this.model.state_name == undefined) {
      this.messageService.showMessage('Please enter state');
      return;
    }

    this.stateService
      .saveState(this.model)
      .then(result => {
        if (result) {
          this.messageService.showMessage(this.btnText + ' successfully');
          this.router.navigate(['/state']);
        } else {
          this.messageService.showMessage(this.btnText + ' successfully');
        }
     });
  }

  private getCountries(): void {
    this.stateService
      .getCountries()
      .then(result => {
        this.countries = result;
        if (this.stateId && this.stateId !== 0) {
          this.getStateByID(this.stateId);
          this.btnText = 'Update State';
        } else {
          this.btnText = 'Save State';
        }
      });
  }

  private getStateByID(stateId: number): void {
    this.stateService
      .getStateByID(stateId)
      .then(result => {
        this.model = result[0];  
      });
  }
}
