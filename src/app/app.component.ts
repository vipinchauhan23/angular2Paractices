import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { Location } from '@angular/common';
import { LocalStorageService } from 'angular-2-local-storage';
import { BaseComponent } from './components/base.component';

@Component({
  moduleId: module.id,
  selector: 'my-app',
  template: `<div class="col-md-12" [hidden]="!user">
      
          <a class="btn" routerLink="/questions" routerLinkActive="active">Questions</a>
          <a class="btn" routerLink="/questionSets" routerLinkActive="active">Question Sets</a>
          <a class="btn" routerLink="/topics" routerLinkActive="active">Topic</a>
          <a class="btn" routerLink="/companies" routerLinkActive="active">Companies</a>
          <a class="btn" routerLink="/users" routerLinkActive="active">Users</a>
          <a class="btn" routerLink="/onlineTests" routerLinkActive="active">Online Test</a>
          <a class="btn" (click)=logout()>Logout</a>
          <a class="btn" routerLink="/country" routerLinkActive="active">Country</a>
          <a class="btn" routerLink="/state" routerLinkActive="active">State</a>
          <a class="btn" routerLink="/city" routerLinkActive="active">City</a>
          <a class="btn" routerLink="/qualification" routerLinkActive="active">Qualification</a>
          <a class="btn" routerLink="/bp" routerLinkActive="active">Business Partner</a>
          <a class="btn" routerLink="/travel" routerLinkActive="active">Travel</a>
          <a class="btn" routerLink="/erecord" routerLinkActive="active">Employee Record</a>
          <a class="btn" routerLink="/product" routerLinkActive="active">Product</a>
    </div>
    <div class="col-md-12">
    <router-outlet></router-outlet></div>`,
  styleUrls: ['app.component.css']
})
export class AppComponent extends BaseComponent {
  authorization: any;
  title = 'Online Test';
  constructor(
    localStorageService: LocalStorageService,
    router: Router,
    location: Location) {
    super(localStorageService, router, location);
  }

  logout(): void {
    this.authorization = this.localStorageService.get('authorization');
    if (this.authorization) {
      this.localStorageService.remove('authorization');
      this.localStorageService.remove('user');
    }
    this.location.replaceState('/login');
    location.reload();
  }
}
