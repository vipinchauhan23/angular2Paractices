import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { Location } from '@angular/common';
import { LocalStorageService } from 'angular-2-local-storage';
import { BaseComponent } from '../../base.component';
import { OnlineTest, OnlineTestUser } from '../../../shared/model/online-test/online-test.model';
import { QuestionSet } from '../../../shared/model/question-set/question-set.model';
import { OnlineTestService } from '../../../shared/services/online-test/online-test.service';
import { QuestionSetService } from '../../../shared/services/question-set/question-set.service';
import { MessageService } from '../../../shared/services/message/message.service'
@Component({
  moduleId: module.id,
  selector: 'online-test',
  templateUrl: 'online-test.component.html',
})
export class OnlineTestComponent extends BaseComponent implements OnInit {
  private model: OnlineTest;
  private onlineTestId: number;
  private questionSets: QuestionSet[] = [];
  private onlineTestUsers: OnlineTestUser[] = [];
  private users: OnlineTestUser[] = [];
  private isAddTestUser: boolean;

  constructor(private onlineTestService: OnlineTestService,
    private messageService: MessageService,
    private questionSetService: QuestionSetService,
    private activatedRoute: ActivatedRoute,
    localStorageService: LocalStorageService,
    router: Router,
    location: Location) {
    super(localStorageService, router, location);
    this.model = new OnlineTest();
    this.model.onlineTestUsers = new Array<OnlineTestUser>();
    this.isAddTestUser = true;
  }

  ngOnInit(): void {
    if (this.user) {
      this.activatedRoute.params.subscribe(params => {
        this.onlineTestId = +params['onlineTestId'];
      });
      this.getQuestionSet();
    }
  }

  addTestUser(): void {
    this.isAddTestUser = false;
    let deletedUsers = this.onlineTestUsers.filter(user => user.is_deleted === 1 && +user.is_selected === 0);
    for (let i = 0; i < deletedUsers.length; i++) {
      this.users.splice(this.users.length, 0, deletedUsers[i]);
    }
  }

  insertTestUser(): void {
    this.isAddTestUser = true;
    let users = this.users.filter(user => +user.is_selected === 1);
    this.users = this.users.filter(user => +user.is_selected === 0);

    for (let i = 0; i < users.length; i++) {
      let testUser = this.onlineTestUsers.filter(user => user.user_id === users[i].user_id);
      if (!testUser[0]) {
        users[0].is_deleted = 0;
        users[i].is_selected = users[i].is_selected ? 1 : 0;
        this.onlineTestUsers.splice(this.onlineTestUsers.length, 0, users[i]);
      }
    }
  }

  deleteOnlineTestUser(user: OnlineTestUser, index: number): void {
    user.is_selected = 0;
    if (user.online_test_user_id === 0) {
      user.is_deleted = 0;
      this.users.splice(this.users.length, 0, user);
      this.onlineTestUsers.splice(index, 1);
    } else {
      user.is_deleted = 1;
    }
  }

  saveOnlineTest(): void {
    this.onlineTestService
      .saveOnlineTest(this.model)
      .then(result => {
        if (result) {
          this.messageService.showMessage('OnlineTest save successfully');
          this.router.navigate(['/onlineTests']);
        }
      });
  }

  private getQuestionSet(): void {
    this.questionSetService
      .getQuestionSets()
      .then(questionSets => {
        if (questionSets) {
          this.questionSets = questionSets;
          if (this.onlineTestId > 0) {
            this.getOnlineTest(this.onlineTestId);
          }
        }
      });
  }

  private getOnlineTest(onlineTestId: number): void {
    this.onlineTestService
      .getOnlineTest(onlineTestId)
      .then(result => {
        this.model = result;
        this.users = this.model.onlineTestUsers.filter(user => +user.is_selected === 0);
        this.onlineTestUsers = this.model.onlineTestUsers.filter(user => +user.is_selected === 1);
      });
  }
}
