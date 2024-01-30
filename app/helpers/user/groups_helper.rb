module User::GroupsHelper

  def group_owner?(group)
    group.owner_id == current_user.id
  end

end
