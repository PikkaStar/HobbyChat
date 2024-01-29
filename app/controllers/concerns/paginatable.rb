module Paginatable
  extend ActiveSupport::Concern

  class_methods do
    def paginate_items(items, page, per)
      Kaminari.paginate_array(items).page(page).per(per)
    end
  end
end