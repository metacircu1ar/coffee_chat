class UnreadCountShowing
    include ServicesHelpers
  
    def show_unread_count(user, params)
      run_result_method(:do_show_unread_count, user, params)
    end
  
    private 
  
    def do_show_unread_count(user, params)
      chat = yield chat_exists?(user, params[:chat_id])
      unread_count = yield unread_count_exists?(chat, user.id)
      Ok[id: unread_count.id, unread_count: unread_count.count]
    end
  end
    