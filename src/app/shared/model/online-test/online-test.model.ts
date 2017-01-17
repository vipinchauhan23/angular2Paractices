export class OnlineTest {
  online_test_id: number = 0;
  company_id: number = 0;
  online_test_title: string = '';
  test_start_date: string = '';
  test_start_time: string = '';
  test_end_date: string = '';
  test_end_time: string = '';
  question_set_id: number = 0;
  test_support_text: string = '';
  test_experience_years: number = 0;
  created_by: string = '';
  updated_by: string = '';

  onlineTestUsers: OnlineTestUser[] = [];
}

export class OnlineTestUser {
  user_id: number = 0;
  user_name: string = '';
  user_email: string = '';
  user_mobile_no: string = '';
  is_fresher: number = 0;
  user_exp_year: number = 0;
  online_test_user_id: number = 0;
  online_test_id: number = 0;

  is_deleted: number = 0;
  is_selected: number = 0;
}
