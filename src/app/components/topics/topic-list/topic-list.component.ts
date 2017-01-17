import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { Location } from '@angular/common';
import { LocalStorageService } from 'angular-2-local-storage';
import { BaseComponent } from '../../base.component';
import { Topic } from '../../../shared/model/topic/topic.model';
import { TopicService } from '../../../shared/services/topic/topic.service';
import { MessageService } from '../../../shared/services/message/message.service';

@Component({
  moduleId: module.id,
  selector: 'app-topiclist',
  templateUrl: 'topic-list.component.html',
})
export class TopicListComponent extends BaseComponent implements OnInit {
  private selectedTopic: Topic;
  private model: Topic[] = [];

  constructor(private topicService: TopicService, private messageService: MessageService,
    localStorageService: LocalStorageService,
    router: Router,
    location: Location) {
    super(localStorageService, router, location);
    this.selectedTopic = new Topic();
    this.model = new Array<Topic>();
  }

  ngOnInit(): void {
    if (this.user) {
      this.getTopic();
    }
  }

  editTopic(topicId: number): void {
    this.router.navigate(['/topic', topicId]);
  }

  showTopic(): void {
    this.router.navigate(['/topic', 0]);
  }

  removeItem(item: Topic): void {
    this.topicService
      .removeTopic(item.topic_id)
      .then(result => {
        if (result) {
          this.messageService.showMessage('Topic deleted!');
          this.getTopic();
        } else {
          this.messageService.showMessage('Topic not deleted!');
        }
      });
  }

  private getTopic(): void {
    this.topicService
      .getTopic()
      .then(result => {
        if (result) {
         // this.messageService.showMessage('Topic loaded successfully');
          this.model = result;
        }
      });
  }
}
