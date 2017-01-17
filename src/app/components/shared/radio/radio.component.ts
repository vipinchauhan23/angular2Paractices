import { Component, Input } from '@angular/core';
import { QuestionOption } from '../../../shared/model/question/question-option.model';
@Component({
  moduleId: module.id,
  selector: 'app-radio',
  templateUrl: 'radio.component.html',
  styleUrls: ['radio.component.css']
})
export class RadioComponent {
  @Input() model: QuestionOption;

  //  valueChanged(value) {
  //   // alert(JSON.stringify(value));
  //   console.log(value);
  // }

}
