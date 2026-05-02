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
require "test_helper"

class HomeSearchTest < ActiveSupport::TestCase
  test "belongs to a search through delegated type" do
    home_search = home_searches(:two)

    assert_equal searches(:two), home_search.search
  end
end
