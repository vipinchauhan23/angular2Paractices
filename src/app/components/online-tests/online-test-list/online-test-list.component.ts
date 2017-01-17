import { Router } from '@angular/router';
import { Component, OnInit } from '@angular/core';
import { Location } from '@angular/common';
import { LocalStorageService } from 'angular-2-local-storage';
import { BaseComponent } from '../../base.component';
import { OnlineTest } from '../../../shared/model/online-test/online-test.model';
import { OnlineTestService } from '../../../shared/services/online-test/online-test.service';
import { MessageService } from '../../../shared/services/message/message.service';


@Component({
  moduleId: module.id,
  selector: 'online-test-list',
  templateUrl: 'online-test-list.component.html',
})
export class OnlineTestListComponent extends BaseComponent implements OnInit {
  private onlineTestData: OnlineTest[] = [];

  constructor(private onlineTestService: OnlineTestService,
    localStorageService: LocalStorageService, private messageService: MessageService,
    router: Router,
    location: Location) {
    super(localStorageService, router, location);
  }

  ngOnInit(): void {
    if (this.user) {
      this.getOnlineTests();
    }
  }

  showTest(onlineTestId: number): void {
    this.router.navigate(['/onlineTest/' + onlineTestId]);
  }

  removeTest(item: OnlineTest): void {
    this.onlineTestService
      .removeOnlineTest(item.online_test_id)
      .then(result => {
        if (result) {
          this.messageService.showMessage('test deleted!');
          this.getOnlineTests();
        }
      });
  }

  private getOnlineTests(): void {
    this.onlineTestService
      .getOnlineTests()
      .then(onlineTests => {
        this.onlineTestData = onlineTests;
       // this.messageService.showMessage('test loaded succssfully');
      });
  }

}
