import { QuestionOption } from './question-option.model';

export class Question {
  question_id: number = 0;
  question_description: string = '';
  company_id: number = 0;
  topic_id: number = 0;
  is_multiple_option: boolean = false;
  answer_explanation: string = '';
  created_by: string = '';
  updated_by: string = '';
  created_datetime: string = '';
  updated_datetime: string = '';
  options: QuestionOption[] = [];
  QuestionStateInfo: string = '';
  is_selected: boolean = false;
}
