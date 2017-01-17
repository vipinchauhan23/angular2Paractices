import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { FormBuilder, FormGroup, Validators, FormControl } from '@angular/forms';
import { Location } from '@angular/common';
import { LocalStorageService } from 'angular-2-local-storage';
import { BaseComponent } from '../../base.component';
import { BusinessPartner } from '../../../shared/model/businesspartner/businessPartner.model';
import { Group } from '../../../shared/model/group/group.model';
import { BusinessPartnerService } from '../../../shared/services/businessPartner/businessPartner.service';
import { MessageService } from '../../../shared/services/message/message.service';
import { General } from '../../../shared/model/general/general.model';
import { GeneralComponent } from '../../shared/general/general.component';


@Component({
  moduleId: module.id,
  selector: 'app-businessPartner',
  templateUrl: 'businessPartner.component.html',
})
export class BusinessPartnerComponent extends BaseComponent implements OnInit {
  public model: BusinessPartner;
  public generalComponent: GeneralComponent;
  private businessPartnerId: number;
  private groups: Group[] = [];
  public bpForm: FormGroup;

  constructor(private businessPartnerService: BusinessPartnerService,
    private messageService: MessageService,
    private activatedRoute: ActivatedRoute,
    private formBuilder: FormBuilder,
    localStorageService: LocalStorageService,
    router: Router,
    location: Location) {
    super(localStorageService, router, location);
    this.model = new BusinessPartner();
    this.model.general = new General();
    this.groups = new Array<Group>();

    this.bpForm = this.formBuilder.group({
      businessPartnerMasterType: [null, [Validators.required, Validators.nullValidator]],
      currency_type: [0, [Validators.required, Validators.minLength(5), Validators.nullValidator]],
      name: ['', [Validators.required, Validators.minLength(5), Validators.nullValidator]],
      account_balance: [0, [Validators.required, Validators.nullValidator]],
      foreign_name: ['', [Validators.required, Validators.minLength(5)]],
      deliveries: [0, [Validators.required, Validators.minLength(5), Validators.nullValidator]],
      group_id: [null, [Validators.required, Validators.nullValidator]],
      orders: [0, [Validators.required, Validators.nullValidator]],
      currency: [null, [Validators.required, Validators.nullValidator]],
      opportunities: [0, [Validators.required, Validators.nullValidator]],
      federal_tax_id: ['', [Validators.required, Validators.minLength(5)]],
      //paymentMethod: this.generalComponent.initgeneral();
    });
  }

//  numberValidator(control: any) {
//     if (control.value.match(/^\d+/)) {
//       return null;
//     } else {
//       return true;
//     }
//   }
  private businessPartnertypes: Array<any> = [{ id: 1, businessPartnertype: 'Customer' },
  { id: 2, businessPartnertype: 'Vender' }];

  private currencyTypes: Array<any> = [{ id: 1, currency_type: 'Local Currency' },
  { id: 2, currency_type: 'International Currency' }];

  private currencyArray: Array<any> = [{ id: 1, currency: 'US Dollor' },
  { id: 2, currency: 'Rupees' }];

  public ngOnInit(): void {
    if (this.user) {
      this.activatedRoute.params.subscribe(params => {
        this.businessPartnerId = +params['bpId']; // (+) converts string 'id' to a number
      });
      this.getGroups();
    }
  }

  saveBusinessPartnerData() {

    if (this.bpForm.valid) {
      console.log(this.bpForm.value);
    }
    // let alertString: String = 'Please select';
    // if (this.model.businesspartnermastertype == 0) {
    //   alertString += '\n BusinessPartner Type \n';
    // }
    // if (this.model.currency === 0) {
    //   alertString += 'select Currency \n';
    // }
    // //   alert(alertString);

    // if (this.model.currency_type === 0) {
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
    // if (this.model.account_balance === undefined) {
    //   alertString += 'enter Account Balance \n';
    // }

    // if (this.model.opportunities === undefined) {
    //   alertString += 'enter Opportunities \n';
    // }
    // if (alertString !== 'Please select') {
    //   this.messageService.showMessage(alertString);
    //   return;
    // }

    this.model.general.active = +this.model.general.active;
    this.model.general.advance = +this.model.general.advance;
    this.model.general.inactive = +this.model.general.inactive;
    this.model.general.send_marketing_content = +this.model.general.send_marketing_content;

    this.businessPartnerService
      .saveBusinessPartnerMaster(this.model)
      .then(result => {
        if (result) {
          this.messageService.showMessage('Saved BusinessPartner data Successfully');
          this.router.navigate(['/bp']);
        } else {
          this.messageService.showMessage('BusinessPartner data not saved ');
        }
      });
  }

  private getGroups() {
    this.businessPartnerService
      .getGroups()
      .then(result => {
        this.groups = result;
        if (this.businessPartnerId && this.businessPartnerId !== 0) {
          this.getBusinessPartnerById(this.businessPartnerId);
        }
        // else{
        //    this.model = new BusinessPartner(null);
        // }
      });
  }
  private getBusinessPartnerById(businessPartnerId: number): void {
    this.businessPartnerService
      .getBusinessPartnerById(businessPartnerId)
      .then(result => {
        // this.model = new BusinessPartner(result[0]);
        // (<FormGroup>this.bpForm)
        //     .setValue(result[0], { onlySelf: true });
        (<FormControl>this.bpForm.controls['name'])
    .setValue( result[0].name, { onlySelf: true });
     (<FormControl>this.bpForm.controls['businessPartnerMasterType'])
    .setValue( result[0].businesspartnermastertype, { onlySelf: true });
     (<FormControl>this.bpForm.controls['currency_type'])
    .setValue( result[0].currency_type, { onlySelf: true });
        // this.bpForm.controls['name'] = result[0].businesspartnermastertype;
        // this.bpForm.controls['businessPartnerMasterType'] = result[0].name;
        this.model.general = result[1];
      });
  }

  private cancel(): void {
    this.router.navigate(['/bp']);
  }
}
