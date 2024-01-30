module ApplicationHelper
  def strftime(time)
    time.strftime("%Y/%m/%d")
  end

  def my_user?(user)
    user == current_user
  end

  def guest_user?(user)
    user.email == "guest@example.com"
  end

end
