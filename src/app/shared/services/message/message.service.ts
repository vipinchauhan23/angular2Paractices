import { Injectable } from '@angular/core';

declare var Materialize: any;

@Injectable()
export class MessageService {
// private message : string 
  constructor() {

  }

  showMessage(message: any) {
    Materialize.toast(message, 1000, 'rounded');
  }
}
