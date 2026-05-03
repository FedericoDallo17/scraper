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
require "test_helper"

class SearchRunTest < ActiveSupport::TestCase
  test "belongs to search and source" do
    search_run = search_runs(:succeeded_job_run)

    assert_equal searches(:one), search_run.search
    assert_equal sources(:two), search_run.source
  end

  test "allows pending runs without timestamps" do
    search_run = SearchRun.new(
      search: searches(:one),
      source: sources(:two),
      status: :pending
    )

    assert_predicate search_run, :valid?
  end

  test "requires started_at when running" do
    search_run = SearchRun.new(
      search: searches(:one),
      source: sources(:two),
      status: :running
    )

    assert_not search_run.valid?
    assert_includes search_run.errors[:started_at], "can't be blank"
  end

  test "allows running runs without finished_at" do
    search_run = SearchRun.new(
      search: searches(:one),
      source: sources(:two),
      status: :running,
      started_at: Time.current
    )

    assert_predicate search_run, :valid?
  end

  test "requires timestamps and results_count when succeeded" do
    search_run = SearchRun.new(
      search: searches(:one),
      source: sources(:two),
      status: :succeeded,
      started_at: Time.current
    )

    assert_not search_run.valid?
    assert_includes search_run.errors[:finished_at], "can't be blank"
    assert_includes search_run.errors[:results_count], "can't be blank"
  end

  test "requires failure details when failed" do
    search_run = SearchRun.new(
      search: searches(:two),
      source: sources(:one),
      status: :failed,
      started_at: Time.current,
      finished_at: 1.minute.from_now
    )

    assert_not search_run.valid?
    assert_includes search_run.errors[:error_class], "can't be blank"
    assert_includes search_run.errors[:error_message], "can't be blank"
  end

  test "requires non-negative results_count" do
    search_run = search_runs(:succeeded_job_run).dup
    search_run.results_count = -1

    assert_not search_run.valid?
    assert_includes search_run.errors[:results_count], "must be greater than or equal to 0"
  end

  test "requires finished_at to be after started_at" do
    search_run = search_runs(:succeeded_job_run).dup
    search_run.started_at = Time.current
    search_run.finished_at = search_run.started_at - 1.minute

    assert_not search_run.valid?
    assert search_run.errors[:finished_at].any? { |message| message.include?("greater than or equal to") }
  end

  test "rejects incompatible source kinds" do
    search_run = SearchRun.new(
      search: searches(:one),
      source: sources(:one),
      status: :pending
    )

    assert_not search_run.valid?
    assert_includes search_run.errors[:source], "is not compatible with search type"
  end

  test "raises on invalid status assignment" do
    assert_raises ArgumentError do
      SearchRun.new(status: :queued)
    end
  end
end
