
export class QuestionSet {
  question_set_id: number = 0;
  question_set_title: string = '';
  total_time: number = 0;
  company_id: number = 0;
  total_questions: number = 0;
  is_randomize: boolean = false;
  option_series_id: number = 0;
  created_by: string = '';
  updated_by: string = '';
  created_datetime: string = '';
  updated_datetime: string = '';
  question_set_questions: QuestionSetQuestion[] = [];
}

export class QuestionSetQuestion {
  question_set_question_id: number = 0;
  question_set_id: number = 0;
  question_id: number = 0;
  question_description: string = '';
  is_deleted: number = 0;
}
