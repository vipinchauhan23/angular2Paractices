import { Component, OnInit } from '@angular/core';
import { Router} from '@angular/router';
import { Location } from '@angular/common';
import { LocalStorageService } from 'angular-2-local-storage';

import {BaseComponent} from '../../base.component';

import { StatInfo } from '../../../shared/model/stats/stat-info.model';
import { QuestionService } from '../../../shared/services/question/question.service';

@Component({
  moduleId: module.id,
  selector: 'app-statinfo',
  templateUrl: './statinfo.component.html',
})
export class StatinfoComponent extends BaseComponent implements OnInit {

  statInfo: StatInfo;

  constructor(private service: QuestionService,
    localStorageService: LocalStorageService,
    router: Router,
    location: Location) {
    super(localStorageService, router, location);

  }

  ngOnInit(): void {
    // start logic here
  }
}
