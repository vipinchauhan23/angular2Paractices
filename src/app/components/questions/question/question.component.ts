import { Component, OnInit, Input } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { Location } from '@angular/common';
import { LocalStorageService } from 'angular-2-local-storage';
import { BaseComponent } from '../../base.component';
import { ApiUrl } from '../../../shared/api-url.component';
import { Question } from '../../../shared/model/question/question.model';
import { QuestionOption } from '../../../shared/model/question/question-option.model';
import { Topic } from '../../../shared/model/topic/topic.model';
import { MessageService } from '../../../shared/services/message/message.service';
import { TopicService } from '../../../shared/services/topic/topic.service';
import { QuestionService } from '../../../shared/services/question/question.service';
import { QuestionOptionService } from '../../../shared/services/question-option/question-option.service';


declare var tinymce: any;
@Component({
  moduleId: module.id,
  selector: 'app-question',
  templateUrl: 'question.component.html',
  styleUrls: ['question.component.css']
})
export class QuestionComponent extends BaseComponent implements OnInit {
  @Input() model: Question;

  private questionId: number;
  private topics: Topic[] = [];
  private froalaOptions: any;
  private newOption: string;

  constructor(private questionService: QuestionService,
    private messageService: MessageService,
    private topicService: TopicService,
    private activatedRoute: ActivatedRoute,
    private questionOptionService: QuestionOptionService,
    localStorageService: LocalStorageService,
    router: Router,
    location: Location) {
    super(localStorageService, router, location);

    this.model = new Question();
    this.model.options = new Array<QuestionOption>();
    this.model.answer_explanation = '';

    this.newOption = '';
    this.model.is_multiple_option = false;
    this.model.question_id = 0;
  }

  ngOnInit(): void {
    if (this.user) {
      this.initializeFloraEditor();
      this.activatedRoute.params.subscribe(params => {
        this.questionId = +params['questionId']; // (+) converts string 'id' to a number
      });

      this.getTopic();
    }
  }

  valueChanged(value: boolean): void {
    this.model.is_multiple_option = !this.model.is_multiple_option;
    this.model.options.forEach(function (option) {
      option.is_correct = false;
    });
  }

  addOption(): void {
    if (this.newOption === '') {
      alert('can not be blank');  // should be removed
    } else {
      this.model.options.push({
        description: this.newOption,
        is_correct: false,
        option_id: 0,
        question_id: this.model.question_id
      });
      this.newOption = '';
    }
  }

  saveQuestion(): void {
    this.questionService
      .saveQuestion(this.model)
      .then(result => {
        if (result) {
          this.messageService.showMessage('save question succesfully');
        }
        this.router.navigate(['/questions']);
      });
  }

  cancel(): void {
    this.router.navigate(['/questions']);
  }

  private initializeFloraEditor() {
    this.froalaOptions = {
      placeholderText: 'Edit Your Content Here!',
      charCounterCount: false,
      imageUploadURL: ApiUrl.baseUrl + 'file/upload'
    };

  }

  private getTopic() {
    this.topicService
      .getTopic()
      .then(result => {
        this.topics = result;
        this.getQuestionById();
      });
  }

  private getQuestionById() {
    if (this.questionId !== 0) {
      this.questionService
        .getQuestionById(this.questionId)
        .then(result => {
          if (result) {
            this.model = result;
          } else {
            this.router.navigate(['/questions']);
          }
        });
    }
  }

}
