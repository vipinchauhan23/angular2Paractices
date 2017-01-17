import { Router } from '@angular/router';
import { Component, OnInit } from '@angular/core';
import { Location } from '@angular/common';
import { LocalStorageService } from 'angular-2-local-storage';

import { BaseComponent } from '../../base.component';
import { MessageService } from '../../../shared/services/message/message.service'
import { Company } from '../../../shared/model/company/company.model';
import { CompanyService } from '../../../shared/services/company/company.service';

@Component({
  moduleId: module.id,
  selector: 'app-companies',
  templateUrl: 'company-list.component.html',
})
export class CompanyListComponent extends BaseComponent implements OnInit {

  private model: Company[] = [];

  constructor(private companyService: CompanyService, private messageService: MessageService,
    localStorageService: LocalStorageService,
    router: Router,
    location: Location) {
    super(localStorageService, router, location);
  }

  ngOnInit(): void {
    if (this.user) {
      this.getCompanies();
    }
  }

  addCompany(): void {
    this.router.navigate(['/company/0']);
  }

  editCompany(companyId: number): void {
    this.router.navigate(['/company/' + companyId]);
  }

  private getCompanies(): void {
    this.companyService
      .getCompanies()
      .then(companies => {
          //this.messageService.showMessage('Companies loaded sucessfully!');
          this.model = companies;
      });
  }
}
