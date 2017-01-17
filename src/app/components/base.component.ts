import { Router} from '@angular/router';
import { Location } from '@angular/common';
import { LocalStorageService } from 'angular-2-local-storage';

export class BaseComponent {
  user: any;

  constructor(protected localStorageService: LocalStorageService,
    protected router: Router,
    protected location: Location) {
    let token = this.localStorageService.get('authorization');
    if (token) {
      this.user = this.localStorageService.get('user');
      if (this.router.url === '/login') {
        this.router.navigate(['/questions']);
      }
    } else {
      if (this.router.url !== '/login' && this.router.url !== '/') {
        this.location.replaceState('/login');
        window.location.reload();
      }
    }
  }
}
