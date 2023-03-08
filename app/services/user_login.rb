class UserLogin
  include ServicesHelpers

  def log_in_user(params)
    run_result_method(:do_log_in_user, params)  
  end

  private

  def do_log_in_user(params)
    email = params[:email].downcase
    user = yield user_exists_by_email?(email)
    yield is_user_password_correct?(user, params[:password])
    new_cookie = user.generate_and_save_new_cookie
    Ok[user_id: user.id, cookie: new_cookie]
  end
end