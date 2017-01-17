import { Component, OnInit , Input,  trigger, state, style, transition, animate,keyframes,SecurityContext,Sanitizer} from '@angular/core';
import { Router} from '@angular/router';
import { Location } from '@angular/common';
import { LocalStorageService } from 'angular-2-local-storage';
import { BaseComponent } from '../../base.component';
import { StatInfo } from '../../../shared/model/stats/stat-info.model';
import { Question } from '../../../shared/model/question/question.model';
import { QuestionService } from '../../../shared/services/question/question.service';
import { QuestionOptionService } from '../../../shared/services/question-option/question-option.service';
import { MessageService } from '../../../shared/services/message/message.service';

@Component({
  moduleId: module.id,
  selector: 'app-questions',
  templateUrl: 'question-list.component.html',
  styleUrls: ['question-list.component.css'],
   animations: [
  trigger('flyInOut', [
  
    transition('* =>1', [
      animate(2000, keyframes([
        style({opacity: 0, transform: 'translateX(-100%)', offset: 0}),
        style({opacity: 1, transform: 'translateX(100%)',  offset: 0.5}),
        style({opacity: 1, transform: 'translateX(0)',     offset: 1.0})
      ]))
    ]),
    transition('* =>2', [
      animate(1000, keyframes([
        style({opacity: 1, transform: 'translateX(0)',     offset: 0}),
        style({opacity: 1, transform: 'translateX(-15px)', offset: 0.7}),
        style({opacity: 0, transform: 'translateX(100%)',  offset: 1.0})
      ]))
    ])
    ,
    transition('* =>3', [
      animate(2500, keyframes([
        style({opacity: 1, transform: 'translateX(0)',     offset: 0}),
        style({opacity: 1, transform: 'translateX(-15px)', offset: 0.8}),
        style({opacity: 0, transform: 'translateX(100%)',  offset: 1.0})
      ]))
    ])
  ])
]
})
export class QuestionListComponent extends BaseComponent implements OnInit {
  private statInfo: StatInfo;
  private model: Question[] = [];
  private selectedQuestion: Question;

  constructor(private questionService: QuestionService,
    private questionOptionService: QuestionOptionService,
    private sanitize: Sanitizer,
    private messageService : MessageService,
    localStorageService: LocalStorageService,
    router: Router,
    location: Location) {
    super(localStorageService, router, location);
    this.statInfo = new StatInfo();
    this.model = new Array<Question>();
    this.selectedQuestion = new Question();
    this.selectedQuestion.answer_explanation = '';
    
  }

  ngOnInit(): void {
    if (this.user) {
      this.getQuestionStateInfo();
    
    }
  }

  selectQuestion(selectedQuestion: Question): void {
    this.selectedQuestion = selectedQuestion;
    this.router.navigate(['/question', selectedQuestion.question_id]);
    
  }

  addQuestion(): void {
    this.router.navigate(['/question', 0]);
  }

  private getQuestionStateInfo(): void {
    this.questionService
      .getQuestionsStateInfo()
      .then(result => {
        if (result) {
          this.messageService.showMessage('questions loaded successfully');
          this.model = result;
        }
      });
  }

}
