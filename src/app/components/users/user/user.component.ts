import { Component, OnInit } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { Location } from '@angular/common';
import { LocalStorageService } from 'angular-2-local-storage';
import { BaseComponent } from '../../base.component';
import { MessageService } from '../../../shared/services/message/message.service';
import { User } from '../../../shared/model/user/user.model';
import { UserService } from '../../../shared/services/user/user.service';

@Component({
  moduleId: module.id,
  selector: 'app-user',
  templateUrl: 'user.component.html'
})
export class UserComponent extends BaseComponent implements OnInit {
  private title: string;
  private model: User;
  private userId: number;
  private disabled: boolean;

  constructor(private userService: UserService,
    private activatedRoute: ActivatedRoute,
    private messageService:MessageService,
    localStorageService: LocalStorageService,
    router: Router,
    location: Location) {
    super(localStorageService, router, location);
    this.title = 'User';
    this.model = new User();
    this.disabled = false;
  }

  ngOnInit(): void {
    if (this.user) {
      this.activatedRoute.params.subscribe(params => {
        this.userId = +params['userId']; // (+) converts string 'id' to a number
      });

      if (this.userId && this.userId !== 0) {
        this.getUser(this.userId);
      }
    }
  }

  searchUserByEmail(): void {
    this.userService
      .searchUserByEmail(this.model.user_email)
      .then(user => {
        if (user.user_id) {
          this.disabled = true;
          this.model = user;
        } else {
          this.disabled = false;
        }
      });
  }

  saveUser(): void {
    this.userService
      .saveUser(this.model)
      .then(user => {
        if (user) {
          this.messageService.showMessage('user saved successfully');
          this.router.navigate(['/users']);
        }
      });
  }

  cancel(): void {
    this.router.navigate(['/users']);
  }

  private getUser(userId: number): void {
    this.userService
      .getUser(userId)
      .then(user => {
        if (user.user_id) {
          this.model = user;
        } else {
          this.router.navigate(['/users']);
        }
      });
  }
}
