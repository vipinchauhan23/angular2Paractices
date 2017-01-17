import { EventEmitter} from '@angular/core';
import {Http, Request, RequestOptionsArgs, Response, RequestOptions, ConnectionBackend, Headers} from '@angular/http';
import { Location } from '@angular/common';
import { Router} from '@angular/router';
import { Observable } from 'rxjs/Rx';
import { LocalStorageService } from 'angular-2-local-storage';

export class HttpInterceptor extends Http {

  authorization: any;
  requested: EventEmitter<string>;
  completed: EventEmitter<string>;
  error: EventEmitter<string>;

  constructor(backend: ConnectionBackend,
    defaultOptions: RequestOptions,
    private router: Router,
    private location: Location,
    private localStorageService: LocalStorageService) {
    super(backend, defaultOptions);
    this.requested = new EventEmitter<string>();
    this.completed = new EventEmitter<string>();
    this.error = new EventEmitter<string>();

  }

  request(url: string | Request, options?: RequestOptionsArgs): Observable<Response> {
    return this.intercept(super.request(url, options));
  }

  get(url: string, options?: RequestOptionsArgs): Observable<Response> {
    // this.requested.emit('start');

    options = this.addHeaders(options);

    return this.intercept(super.get(url, options));
  }

  post(url: string, body: string, options?: RequestOptionsArgs): Observable<Response> {
    // this.requested.emit('start');

    return this.intercept(super.post(url, body, this.getRequestOptionArgs(options)));
  }

  put(url: string, body: string, options?: RequestOptionsArgs): Observable<Response> {
    // this.requested.emit('start');

    return this.intercept(super.put(url, body, this.getRequestOptionArgs(options)));
  }

  delete(url: string, options?: RequestOptionsArgs): Observable<Response> {
    // this.requested.emit('start');
    options = this.addHeaders(options);

    return this.intercept(super.delete(url, options));
  }

  getRequestOptionArgs(options?: RequestOptionsArgs): RequestOptionsArgs {
    options = this.addHeaders(options);
    options.headers.append('Content-Type', 'application/json');
    return options;
  }

  addHeaders(options?: RequestOptionsArgs): RequestOptionsArgs {
    if (options == null) {
      options = new RequestOptions();
    }

    if (options.headers == null) {
      options.headers = new Headers();
    }
    this.authorization = this.localStorageService.get('authorization');
    if (this.authorization) {
      options.headers.append('Authorization', this.authorization);
    }
    return options;
  }

  intercept(observable: Observable<Response>): Observable<Response> {
    // this.completed.emit('end');
    // this.loadingPage.close();
    return observable.catch((err, source) => {
      // this.error.emit(err);
      if (err.status === 401) {                   // UnOthorised Access
        this.authorization = this.localStorageService.get('authorization');
        if (this.authorization) {
          this.localStorageService.remove('authorization');
          this.localStorageService.remove('user');
        }
        if (this.router.url !== '/login') {
          this.location.replaceState('/login');
          window.location.reload();
        }
        return Observable.empty();

      } else if (err.status === 403) {
        console.log('you can not access api');
        return Observable.throw(err);
      } else if (err.status === 0) {                // Api Connection Refused
        console.log('ERR_CONNECTION_REFUSED, Api is down');
        return Observable.throw(err);
      } else {
        return Observable.throw(err);
      }
    });
  }
}
