module ApplicationHelper

  def logged_in?
    !!session[:user_id]
  end

  def current_user
    User.find(session[:user_id])
  end

  def navbar
    if logged_in?
      render 'layouts/logged_in_navbar'
    else
      render 'layouts/logged_out_navbar'
    end
  end

end
