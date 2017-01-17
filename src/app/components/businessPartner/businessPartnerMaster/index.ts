import { ActivatedRoute, Router } from '@angular/router';
import { Location } from '@angular/common';
import { LocalStorageService } from 'angular-2-local-storage';
import { BaseComponent } from '../../base.component';
import { BusinessPartner } from '../../../shared/model/businesspartner/businessPartner.model';
import { Group } from '../../../shared/model/group/group.model';
import { BusinessPartnerService } from '../../../shared/services/businessPartner/businessPartner.service';
import { MessageService } from '../../../shared/services/message/message.service';
import {GeneralComponent} from'../../../components/shared/general/general.component';
import { General } from '../../../shared/model/general/general.model';


export class Index{

}