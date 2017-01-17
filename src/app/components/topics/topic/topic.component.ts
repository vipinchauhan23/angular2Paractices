import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { Location } from '@angular/common';
import { LocalStorageService } from 'angular-2-local-storage';
import {BaseComponent} from '../../base.component';
import { Topic } from '../../../shared/model/topic/topic.model';
import { TopicService } from '../../../shared/services/topic/topic.service';
import { MessageService } from '../../../shared/services/message/message.service';


@Component({
  moduleId: module.id,
  selector: 'app-topic',
  templateUrl: 'topic.component.html'
})
export class TopicComponent extends BaseComponent implements OnInit {
  private model: Topic;
  private btnText: string;
  private topicId: number;

  constructor(private topicService: TopicService,private messageService: MessageService,
    private activatedRoute: ActivatedRoute,
    localStorageService: LocalStorageService,
    router: Router,
    location: Location) {
    super(localStorageService, router, location);
    this.model = new Topic();
  }

  ngOnInit(): void {
    if (this.user) {
      this.activatedRoute.params.subscribe(params => {
        this.topicId = +params['topicId']; // (+) converts string 'id' to a number
      });
      if (this.topicId && this.topicId !== 0) {
        this.getTopicByID(this.topicId);
        this.btnText = 'Update Topic';
      } else {
        this.btnText = 'Save Topic';
      }
    }
  }

  saveTopic(): void {
    this.topicService
      .saveTopic(this.model)
      .then(result => {
        if (result) {
          this.messageService.showMessage(this.btnText + ' successfully');
           this.router.navigate(['/topics']);
        } else {
            this.messageService.showMessage(this.btnText + ' successfully');
        }
      });
  }

  private getTopicByID(topicId: number): void {
    this.topicService
      .getTopicByID(topicId)
      .then(result => {
        this.model = result[0];
        
      });
  }

}
