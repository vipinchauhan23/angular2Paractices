import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { Location } from '@angular/common';
import { LocalStorageService } from 'angular-2-local-storage';
import { BaseComponent} from '../../base.component';
import { Qualification } from '../../../shared/model/qualification/qualification.model';
import { QualificationService } from '../../../shared/services/qualification/qualification.service';
import { MessageService } from '../../../shared/services/message/message.service';

@Component({
  moduleId: module.id,
  selector: 'app-qualification',
  templateUrl:'qualification.component.html'
})
export class QualificationComponent extends BaseComponent implements OnInit {
  private model: Qualification;
  private btnText: string;
  private qualificationId: number;

  constructor(private qualificationService: QualificationService,private messageService: MessageService,
    private activatedRoute: ActivatedRoute,
    localStorageService: LocalStorageService,
    router: Router,
    location: Location) {
    super(localStorageService, router, location);
    this.model = new Qualification();
  }

  ngOnInit(): void {
    if (this.user) {
      this.activatedRoute.params.subscribe(params => {
        this.qualificationId = +params['qualificationId']; // (+) converts string 'id' to a number
      });
      if (this.qualificationId && this.qualificationId !== 0) {
        this.getQualificationByID(this.qualificationId);
        this.btnText = 'Update Qualification';
      } else {
        this.btnText = 'Save Qualification';
      }
    }
  }

  saveCountry(): void {
    
    if (this.model.qualification_name == '' || this.model.qualification_name == undefined) {
      this.messageService.showMessage('please enter qualification!');
      return;
    }
    
    this.qualificationService
      .saveQualification(this.model)
      .then(result => {
        if (result) {
          this.messageService.showMessage(this.btnText + ' successfully');
           this.router.navigate(['/qualification']);
        } else {
            this.messageService.showMessage(this.btnText + ' successfully');
        }
      });
  }

  private getQualificationByID(qualificationId: number): void {
    this.qualificationService
      .getQualificationByID(qualificationId)
      .then(result => {
        this.model = result[0];
        
      });
  }

}
