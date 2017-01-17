import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { Location } from '@angular/common';
import { LocalStorageService } from 'angular-2-local-storage';
import { BaseComponent } from '../../base.component';
import { Qualification } from '../../../shared/model/qualification/qualification.model';
import { QualificationService } from '../../../shared/services/qualification/qualification.service';
import { MessageService } from '../../../shared/services/message/message.service';

@Component({
  moduleId: module.id,
  selector: 'app-qualificationlist',
  templateUrl: 'qualificationlist.component.html',
})
export class QualificationListComponent extends BaseComponent implements OnInit {
  private selectedCountry: Qualification;
  private model: Qualification[] = [];

  constructor(private qualificationService: QualificationService, private messageService: MessageService,
    localStorageService: LocalStorageService,
    router: Router,
    location: Location) {
    super(localStorageService, router, location);
    this.selectedCountry = new Qualification();
    this.model = new Array<Qualification>();
  }

  ngOnInit(): void {
    if (this.user) {
      this.getqualification();
    }
  }

  editQualification(qualificationId: number): void {
    this.router.navigate(['/qualification', qualificationId]);
  }

  showQualification(): void {
    this.router.navigate(['/qualification', 0]);
  }

  removeItem(item: Qualification): void {
    this.qualificationService
      .removeQualification(item.qualification_id)
      .then(result => {
        if (result) {
          this.messageService.showMessage('Qualification deleted!');
          this.getqualification();
        } else {
          this.messageService.showMessage('Qualification not deleted!');
        }
      });
  }

  private getqualification(): void {
    this.qualificationService
      .getQualification()
      .then(result => {
        if (result) {
          this.model = result;
        }
      });
  }
}
