import { Component, OnInit, Input } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { FormBuilder, FormGroup, Validators, FormControl } from '@angular/forms';
import { Location } from '@angular/common';
import { LocalStorageService } from 'angular-2-local-storage';
import { BaseComponent } from '../../base.component';
import { General } from '../../../shared/model/general/general.model';
import { BusinessPartnerService } from '../../../shared/services/businessPartner/businessPartner.service';
import { MessageService } from '../../../shared/services/message/message.service';
@Component({
  moduleId: module.id,
  selector: 'general',
  templateUrl: 'general.component.html'
})
export class GeneralComponent extends BaseComponent implements OnInit {
  private businessPartnerId: number;
  @Input() generalModal: General;
  private initgeneral: FormGroup;

  constructor(private businessPartnerService: BusinessPartnerService,
    private messageService: MessageService,
    private activatedRoute: ActivatedRoute,
    public bpForm: FormGroup,
    private formBuilder: FormBuilder,
    localStorageService: LocalStorageService,
    router: Router,
    location: Location) {
    super(localStorageService, router, location);
  }

  ngOnInit(): void {
    if (this.user) {
      this.activatedRoute.params.subscribe(params => {
        this.businessPartnerId = +params['bpId']; // (+) converts string 'id' to a number
      });
      // this.getGroups();
    }
  }

  initGeneral() {
    const generalMethod = this.formBuilder.group({
      telephone: ['', [Validators.required, Validators.minLength(10), Validators.nullValidator]],
      contact_person: ['', [Validators.required]],
      mobile_phone: ['', [Validators.required, Validators.minLength(10), Validators.nullValidator]],
      email: ['', [Validators.required, Validators.nullValidator]],
      remark: ['', [Validators.required, Validators.nullValidator]],
      web_site: ['', [Validators.required, Validators.nullValidator]],
      shipping_id: [null, [Validators.required, Validators.nullValidator]],
      sales_employee_id: [null, [Validators.required, Validators.nullValidator]]
    });
    return generalMethod;
  }
  private shippingTypeArray: Array<any> = [{ shipping_id: 1, shipping_type: 'Fedex EM' },
  { shipping_id: 2, shipping_type: 'DTDC' },
  { shipping_id: 3, shipping_type: 'Local Corrier' }];

  private salesEmployeeArray: Array<any> = [{ sales_employee_id: 1, sales_employee: 'Brad Thomson' },
  { sales_employee_id: 2, sales_employee: 'Vipin' },
  { sales_employee_id: 3, sales_employee: 'Shashi' }];

  private industryArray: Array<any> = [{ industry_id: 1, industry: 'IT' },
  { industry_id: 2, industry: 'ABC' },
  { industry_id: 3, industry: 'XYZ' }];

  private languageArray: Array<any> = [{ language_id: 1, language: 'English' },
  { language_id: 2, language: 'Hindi' },
  { language_id: 3, language: 'German' }];

}
