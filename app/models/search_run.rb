# == Schema Information
#
# Table name: search_runs
#
#  id            :bigint           not null, primary key
#  error_class   :string
#  error_message :string
#  finished_at   :datetime
#  results_count :integer
#  started_at    :datetime
#  status        :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  search_id     :bigint           not null
#  source_id     :bigint           not null
#
# Indexes
#
#  index_search_runs_on_search_id  (search_id)
#  index_search_runs_on_source_id  (source_id)
#  index_search_runs_on_status     (status)
#
# Foreign Keys
#
#  fk_rails_...  (search_id => searches.id)
#  fk_rails_...  (source_id => sources.id)
#
class SearchRun < ApplicationRecord
  belongs_to :search
  belongs_to :source

  enum :status, { pending: "pending", running: "running", succeeded: "succeeded", failed: "failed" }

  validates :status, presence: true
  validates :started_at, presence: true, if: -> { running? || succeeded? || failed? }
  validates :finished_at, presence: true, if: -> { succeeded? || failed? }
  validates :finished_at, comparison: { greater_than_or_equal_to: :started_at }, if: -> { started_at.present? && finished_at.present? }
  validates :results_count, presence: true, numericality: { greater_than_or_equal_to: 0 }, if: :succeeded?
  validates :results_count, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :error_class, presence: true, if: :failed?
  validates :error_message, presence: true, if: :failed?

  validate :source_kind_matches_search

  private

  def source_kind_matches_search
    return if search.blank? || source.blank?
    return if search.source_kind == source.kind

    errors.add(:source, "is not compatible with search type")
  end
end
