# == Schema Information
#
# Table name: job_searches
#
#  id         :bigint           not null, primary key
#  mode       :string
#  query      :string           not null
#  salary_max :integer
#  salary_min :integer
#  seniority  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "test_helper"

class JobSearchTest < ActiveSupport::TestCase
  test "belongs to a search through delegated type" do
    job_search = job_searches(:one)

    assert_equal searches(:one), job_search.search
  end
end
