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
class JobSearch < ApplicationRecord
  include Searchable

  enum :mode, { remote: "remote", hybrid: "hybrid", on_site: "on_site" }
  enum :seniority, { junior: "junior", semi_senior: "semi_senior", senior: "senior" }

  validates :query, presence: true
  validates :salary_min, allow_nil: true, numericality: { greater_than_or_equal_to: 0 }
  validates :salary_max, allow_nil: true, comparison: { greater_than: :salary_min }
  validates :seniority, presence: true
  validates :mode, presence: true
end
