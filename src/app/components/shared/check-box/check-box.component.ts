import { Component, Input } from '@angular/core';
import { QuestionOption } from '../../../shared/model/question/question-option.model';

@Component({
  moduleId: module.id,
  selector: 'app-check-box',
  templateUrl: 'check-box.component.html',
  styleUrls: ['check-box.component.css']
})
export class CheckBoxComponent {
  @Input() model: QuestionOption;
}
