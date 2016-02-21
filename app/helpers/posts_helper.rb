module PostsHelper
  def back_page_post
    if session[:last_post_page]
      session[:last_post_page]
    else
      posts_main_path
    end
  end
end
