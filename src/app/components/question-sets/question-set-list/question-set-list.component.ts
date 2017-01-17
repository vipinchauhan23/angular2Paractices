import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { Location } from '@angular/common';
import { LocalStorageService } from 'angular-2-local-storage';
import { BaseComponent } from '../../base.component';
import { MessageService } from '../../../shared/services/message/message.service';
import { QuestionSet } from '../../../shared/model/question-set/question-set.model';
import { QuestionSetService } from '../../../shared/services/question-set/question-set.service';

@Component({
  moduleId: module.id,
  selector: 'question-set-list',
  templateUrl: 'question-set-list.component.html'
})
export class QuestionSetListComponent extends BaseComponent implements OnInit {

  private title: string;
  private model: QuestionSet[] = [];
  private selectedQuestionSetId: number;

  constructor(private questionSetService: QuestionSetService,
    private messageService: MessageService,
    localStorageService: LocalStorageService,
    router: Router,
    location: Location) {
    super(localStorageService, router, location);

    this.title = 'Question Sets';
    this.model = new Array<QuestionSet>();
  }

  ngOnInit(): void {
    if (this.user) {
      this.getQuestionSets();
    }
  }

  selectQuestionSet(selectedQuestionSet: QuestionSet): void {
    this.selectedQuestionSetId = selectedQuestionSet.question_set_id;
    this.router.navigate(['/questionSet', this.selectedQuestionSetId]);
  }

  addQuestionSet(): void {
    this.router.navigate(['/questionSet', 0]);
  }

  private getQuestionSets(): void {
    this.questionSetService
      .getQuestionSets()
      .then(questionSets => {
        //this.messageService.showMessage('Questionsets loaded successfully');
        this.model = questionSets;
      });
  }

}
