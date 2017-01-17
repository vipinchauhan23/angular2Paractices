import {Http} from '@angular/http';
import {Injectable} from '@angular/core';

import { ApiUrl } from '../../api-url.component';
import { OptionSeries } from '../../model/question/question-option.model';

@Injectable()
export class QuestionOptionService {

  constructor(private http: Http) {

  }

  getQuestionOptions(questionId: number): any {
    return this
      .http
      .get(ApiUrl.baseUrl + 'questionOptions/' + questionId)
      .toPromise()
      .then(response => response.json())
      .catch(this.handleError);
  }

  getOptionSeries(): Promise<OptionSeries[]> {
    return this
      .http
      .get(ApiUrl.baseUrl + 'optionSeries')
      .toPromise()
      .then(response => response.json() as OptionSeries[])
      .catch(this.handleError);
  }

  private handleError(error: any): Promise<any> {
    console.error('An error occurred', error);
    return Promise.reject(error.message || error);
  }
}
