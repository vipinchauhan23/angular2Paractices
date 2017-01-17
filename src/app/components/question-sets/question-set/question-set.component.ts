import { Component, OnInit } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { Location } from '@angular/common';
import { LocalStorageService } from 'angular-2-local-storage';
import { BaseComponent } from '../../base.component';
import { QuestionSet, QuestionSetQuestion } from '../../../shared/model/question-set/question-set.model';
import { Question } from '../../../shared/model/question/question.model';
import { Topic } from '../../../shared/model/topic/topic.model';
import { OptionSeries } from '../../../shared/model/question/question-option.model';
import { QuestionSetService } from '../../../shared/services/question-set/question-set.service';
import { QuestionService } from '../../../shared/services/question/question.service';
import { TopicService } from '../../../shared/services/topic/topic.service';
import { QuestionOptionService } from '../../../shared/services/question-option/question-option.service';
import { MessageService } from '../../../shared/services/message/message.service';

@Component({
  moduleId: module.id,
  selector: 'question-set',
  templateUrl: 'question-set.component.html',
})
export class QuestionSetComponent extends BaseComponent implements OnInit {

  private title: string;
  private model: QuestionSet;
  private questions: Question[] = [];
  private topics: Topic[] = [];
  private optionSeries: OptionSeries[] = [];
  private selectedTopic: number;
  private isAddQuestion: boolean;
  private questionSetId: number;

  constructor(private questionSetService: QuestionSetService, private messageService: MessageService,
    private questionService: QuestionService,
    private topicService: TopicService,
    private questionOptionService: QuestionOptionService,
    private activatedRoute: ActivatedRoute,
    localStorageService: LocalStorageService,
    router: Router,
    location: Location) {
    super(localStorageService, router, location);
    this.title = 'Question Sets';
    this.model = new QuestionSet();
    this.model.question_set_questions = new Array<QuestionSetQuestion>();
    this.isAddQuestion = false;
  }

  ngOnInit(): void {
    if (this.user) {
      this.activatedRoute.params.subscribe(params => {
        this.questionSetId = +params['questionSetId']; // (+) converts string 'id' to a number
      });
      this.getOptionSeries();
    }
  }

  showQuestions(): void {
    this.isAddQuestion = true;
    this.topicService
      .getTopic()
      .then(topics => {
        this.topics = topics;
        if (this.topics.length > 0) {
          this.selectedTopic = this.topics[0].topic_id;
          this.getQuestions(this.selectedTopic);
        }
      });
  }

  getQuestions(topic_id: number): void {
    this.questionService
      .getQuestionsByTopic(topic_id)
      .then(questions => {
        this.questions = [];
        for (let i = 0; i < questions.length; i++) {
          let selectedQuestion = this.model.question_set_questions.filter(
            ques => ques.question_id === questions[i].question_id && ques.is_deleted === 0);

          if (selectedQuestion.length === 0) {
            this.questions.splice(this.questions.length, 0, questions[i]);
          }
        }
      });
  }

  addQuestionsInQuestionSet(): void {
    this.isAddQuestion = false;

    let selectedQuestions = this.questions.filter(ques => ques.is_selected === true);
    for (let i = 0; i < selectedQuestions.length; i++) {
      let deletedQuestion = this.model.question_set_questions.filter(ques => ques.question_id === selectedQuestions[i].question_id);
      if (deletedQuestion.length > 0) {
        deletedQuestion[0].is_deleted = 0;
      } else {
        let obj = {
          question_set_question_id: 0,
          question_set_id: this.questionSetId,
          question_id: selectedQuestions[i].question_id,
          question_description: selectedQuestions[i].question_description,
          is_deleted: 0
        };
        this.model.question_set_questions.splice(this.model.question_set_questions.length, 0, obj);
      }
    }
  }

  saveQuestionSet(): void {
    this.questionSetService
      .saveQuestionSet(this.model)
      .then(result => {
        this.messageService.showMessage('Save Questionset');
        this.router.navigate(['/questionSets']);
      });
  }

  deleteSetQuestion(question: QuestionSetQuestion, index: number): void {
    if (question.question_set_question_id === 0) {
      this.model.question_set_questions.splice(index, 1);
    } else {
      question.is_deleted = 1;
    }
  }

  private getOptionSeries(): void {
    this.questionOptionService
      .getOptionSeries()
      .then(optionSeries => {
        this.optionSeries = optionSeries;

        if (this.questionSetId && this.questionSetId !== 0) {
          this.getQuestionSet(this.questionSetId);
        } else {
          this.model.question_set_id = this.questionSetId;
        }
      });
  }

  private getQuestionSet(question_set_id: number): void {
    this.questionSetService
      .getQuestionSet(question_set_id)
      .then(questionSet => {
        this.model = questionSet;
      });
  }

}
