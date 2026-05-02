# == Schema Information
#
# Table name: home_searches
#
#  id         :bigint           not null, primary key
#  area_max   :integer
#  area_min   :integer
#  price_max  :integer
#  price_min  :integer
#  rooms      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class HomeSearch < ApplicationRecord
  include Searchable

  validates :area_min, allow_nil: true, numericality: { greater_than_or_equal_to: 0 }
  validates :area_max, allow_nil: true, comparison: { greater_than: :area_min }
  validates :price_min, allow_nil: true, numericality: { greater_than_or_equal_to: 0 }
  validates :price_max, allow_nil: true, comparison: { greater_than: :price_min }
  validates :rooms, allow_nil: true, numericality: { greater_than_or_equal_to: 1 }
end
