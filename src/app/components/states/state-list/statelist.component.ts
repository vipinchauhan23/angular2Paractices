import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { Location } from '@angular/common';
import { LocalStorageService } from 'angular-2-local-storage';
import { BaseComponent } from '../../base.component';
import { State } from '../../../shared/model/state/state.model';
import { StateService } from '../../../shared/services/state/state.service';
import { MessageService } from '../../../shared/services/message/message.service';

@Component({
  moduleId: module.id,
  selector: 'app-statelist',
  templateUrl: 'statelist.component.html',
})
export class StateListComponent extends BaseComponent implements OnInit {
  private selectedState: State;
  private model:State[] = [];

  constructor(private stateService: StateService, private messageService: MessageService,
    localStorageService: LocalStorageService,
    router: Router,
    location: Location) {
    super(localStorageService, router, location);
    this.selectedState = new State();
    this.model = new Array<State>();
  }

  ngOnInit(): void {
    if (this.user) {
      this.getState();
    }
  }

  editState(stateId: number): void {
    this.router.navigate(['/state', stateId]);
  }

  showState(): void {
    this.router.navigate(['/state', 0]);
  }

  removeItem(item: State): void {
    this.stateService
      .removeState(item.state_id)
      .then(result => {
        if (result) {
          this.messageService.showMessage('State deleted!');
          this.getState();
        } else {
          this.messageService.showMessage('State not deleted!');
        }
      });
  }

  private getState(): void {
    this.stateService
      .getState()
      .then(result => {
        if (result) {
          this.model = result;
        }
      });
  }
}
