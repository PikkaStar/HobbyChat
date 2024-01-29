module PaginationGroup
  extend ActiveSupport::Concern

  included do
    before_action :set_groups, only: [:index]
  end

  def set_groups
    @groups = paginate_groups
  end

  def paginate_groups
    if params[:latest]
      Group.latest.page(params[:page]).per(15)
    elsif params[:old]
      Group.old.page(params[:page]).per(15)
    elsif params[:members]
      Kaminari.paginate_array(Group.members).page(params[:page]).per(15)
    else
      Group.page(params[:page]).per(15)
    end
  end

end