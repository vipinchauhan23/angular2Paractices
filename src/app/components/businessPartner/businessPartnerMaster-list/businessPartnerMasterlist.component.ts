import { Component, OnInit, Input } from '@angular/core';
import { Router } from '@angular/router';
import { Location } from '@angular/common';
import { LocalStorageService } from 'angular-2-local-storage';
import { BaseComponent } from '../../base.component';
import { Group } from '../../../shared/model/group/group.model';
import { BusinessPartner } from '../../../shared/model/businesspartner/businessPartner.model';
import { BusinessPartnerService } from '../../../shared/services/businessPartner/businessPartner.service';
import { MessageService } from '../../../shared/services/message/message.service';

@Component({
  moduleId: module.id,
  selector: 'app-businessPartnerMasterlist',
  templateUrl: 'businessPartnerMasterlist.component.html',
})
export class BusinessPartnerListComponent extends BaseComponent implements OnInit {
  private selectedBusinessPartner: BusinessPartner;
  private model: BusinessPartner[] = [];

  constructor(private businessPartnerService: BusinessPartnerService, private messageService: MessageService,
    localStorageService: LocalStorageService,
    router: Router,
    location: Location) {
    super(localStorageService, router, location);
    this.selectedBusinessPartner = new BusinessPartner();
    this.model = new Array<BusinessPartner>();
  }

  ngOnInit(): void {
    if (this.user) {
      this.getBusinessPartners();
    }
  }

  showBusinessPartner(businessPartnerMasterId: number): void {
    this.router.navigate(['/bp', businessPartnerMasterId]);
  }

  removeItem(item: BusinessPartner): void {
    if (confirm("Are you sure you want to delete?")) {
      this.businessPartnerService
        .deleteBusinessPartners(item.businesspartnermaster_id)
        .then(result => {
          if (result) {
            this.messageService.showMessage('BusinessPartner deleted!');
            this.getBusinessPartners();
          } else {
            this.messageService.showMessage('BusinessPartner not deleted!');
          }
        });
    }
  }


  private getBusinessPartners(): void {
    this.businessPartnerService
      .getBusinessPartners()
      .then(result => {
        if (result) {
          this.model = result;
        }
      });
  }
}
