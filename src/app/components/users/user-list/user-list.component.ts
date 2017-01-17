import { Component, OnInit } from '@angular/core';
import { Router} from '@angular/router';
import { Location } from '@angular/common';
import { LocalStorageService } from 'angular-2-local-storage';
import {BaseComponent} from '../../base.component';
import { MessageService } from '../../../shared/services/message/message.service';
import { User } from '../../../shared/model/user/user.model';
import { UserService } from '../../../shared/services/user/user.service';

@Component({
  moduleId: module.id,
  selector: 'user-list',
  templateUrl: 'user-list.component.html',
})
export class UserListComponent extends BaseComponent implements OnInit {

  private title: string;
  private model: User[] = [];
  private selectedUserId: number;

  constructor(private userService: UserService,
  private messageService: MessageService,
    localStorageService: LocalStorageService,
    router: Router,
    location: Location) {
    super(localStorageService, router, location);
    this.title = 'Users';
    this.model = new Array<User>();
  }

  ngOnInit(): void {
    if (this.user) {
      this.getUsers();
    }
  }

  selectUser(selectedUser: User): void {
    this.selectedUserId = selectedUser.user_id;

    this.router.navigate(['/user', this.selectedUserId]);
  }

  addUser(): void {
    this.router.navigate(['/user', 0]);
  }

  private getUsers(): void {
    this.userService
      .getUsers()
      .then(users => {
       // this.messageService.showMessage('user loaded successfully');
        this.model = users;
      });
  }
}
