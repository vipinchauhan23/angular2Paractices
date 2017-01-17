import {Http } from '@angular/http';
import {Injectable} from '@angular/core';

import { ApiUrl } from '../../api-url.component';
import { Question } from '../../model/question/question.model';

@Injectable()
export class QuestionService {

  constructor(private http: Http) {

  }

  getQuestionById(questionId: number) {
    return this
      .http
      .get(ApiUrl.baseUrl + 'questionbyid/' + questionId)
      .toPromise()
      .then(response => response.json() as Question)
      .catch(this.handleError);
  }

  getQuestions(): Promise<Question[]> {
    return this
      .http
      .get(ApiUrl.baseUrl + 'questions')
      .toPromise()
      .then(response => response.json() as Question[])
      .catch(this.handleError);
  }

  getQuestionsByTopic(topicId: number): Promise<Question[]> {
    return this
      .http
      .get(ApiUrl.baseUrl + 'question/' + topicId)
      .toPromise()
      .then(response => response.json() as Question[])
      .catch(this.handleError);
  }

  getQuestionsStateInfo(): Promise<Question[]> {
    return this
      .http
      .get(ApiUrl.baseUrl + 'questionStateInfo')
      .toPromise()
      .then(response => response.json())
      .catch(this.handleError);
  }

  saveQuestion(data: Question): Promise<string> {
    return this
      .http
      .post(ApiUrl.baseUrl + 'question', JSON.stringify(data))
      .toPromise()
      .then(res => res.json())
      .catch(this.handleError);
  }

  deleteQuestion(id: number): any {
    return this
      .http
      .get(ApiUrl.baseUrl + 'deleteQuestion?questionID=' + id);
  }

  private handleError(error: any): Promise<any> {
    console.error('An error occurred', error);
    return Promise.reject(error.message || error);
  }
}
