class Inventory < ApplicationRecord
  has_paper_trail :ignore => [:created_at, :updated_at],
                  :on     => [:update, :destroy]
end
