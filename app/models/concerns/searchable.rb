module Searchable
  extend ActiveSupport::Concern

  included do
    has_one :search, as: :searchable, dependent: :destroy, touch: true

    validates :search, presence: true

    scope :with_search, -> { includes(:search) }
  end
end
