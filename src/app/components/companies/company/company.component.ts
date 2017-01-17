import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { Location } from '@angular/common';
import { LocalStorageService } from 'angular-2-local-storage';
import { BaseComponent } from '../../base.component';
import { Company } from '../../../shared/model/company/company.model';
import { CompanyService } from '../../../shared/services/company/company.service';
import { MessageService } from '../../../shared/services/message/message.service'

@Component({
  moduleId: module.id,
  selector: 'app-company',
  templateUrl: 'company.component.html'
})
export class CompanyComponent extends BaseComponent implements OnInit {
  private model: Company;
  private companyId: number;
  private btnText: string;

  constructor(private companyService: CompanyService, private messageService: MessageService,
    private activatedRoute: ActivatedRoute,
    localStorageService: LocalStorageService,
    router: Router,
    location: Location) {
    super(localStorageService, router, location);
    this.model = new Company();
  }

  ngOnInit(): void {
    if (this.user) {
      this.activatedRoute.params.subscribe((params: any) => {
        this.companyId = +params['companyId'];
      });
      if (this.companyId > 0) {
        this.getCompanyByID();
        this.btnText = 'Update Company'
      }
      else {
        this.btnText = 'Save Company'
      }
    }
  }

  saveCompany(): void {
    this.companyService
      .saveCompany(this.model)
      .then(result => {
        if (result) {
           this.messageService.showMessage(this.btnText + ' succssfully');
           this.router.navigate(['/companies']);
        }
        else {
          this.messageService.showMessage(this.btnText + ' succssfully');
        }
      });
  }

  private getCompanyByID(): void {
    this.companyService
      .getCompanyById(this.companyId)
      .then(result => {
        this.model = result;
      });
  }
}
