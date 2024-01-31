module ApplicationHelper
  def strftime(time)
    time.in_time_zone("Asia/Tokyo").strftime("%Y/%m/%d")
  end

  def strftime_sec(time)
    time.in_time_zone("Asia/Tokyo").strftime("%Y/%m/%d %H:%M:%S")
  end

  def my_user?(user)
    user == current_user
  end

  def guest_user?(user)
    user.email == "guest@example.com"
  end

end
