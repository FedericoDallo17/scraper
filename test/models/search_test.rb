# == Schema Information
#
# Table name: searches
#
#  id              :bigint           not null, primary key
#  active          :boolean          default(TRUE), not null
#  name            :string           not null
#  notes           :string
#  searchable_type :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  searchable_id   :bigint           not null
#  user_id         :bigint           not null
#
# Indexes
#
#  index_searches_on_searchable  (searchable_type,searchable_id)
#  index_searches_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require "test_helper"

class SearchTest < ActiveSupport::TestCase
  test "requires user" do
    search = searches(:one).dup
    search.user = nil

    assert_not(search.valid?)
    assert_includes(search.errors[:user], "must exist")
  end

  test "requires name" do
    search = searches(:one).dup
    search.name = nil

    assert_not(search.valid?)
    assert_includes(search.errors[:name], "can't be blank")
  end

  test "requires searchable" do
    search = searches(:one).dup
    search.searchable = nil

    assert_not(search.valid?)
    assert_includes(search.errors[:searchable], "can't be blank")
  end

  test "delegates to a job search" do
    search = searches(:one)

    assert_instance_of JobSearch, search.searchable
    assert_equal "Junior React Developer", search.searchable.query
  end

  test "delegates to a home search" do
    search = searches(:two)

    assert_instance_of HomeSearch, search.searchable
  end

  test "defaults active to true" do
    search = Search.create!(
      user: users(:one),
      name: "Senior Rails roles",
      searchable: job_searches(:one)
    )

    assert_predicate search, :active?
  end

  test "returns job as source kind for job searches" do
    assert_equal "job", searches(:one).source_kind
  end

  test "returns home as source kind for home searches" do
    assert_equal "home", searches(:two).source_kind
  end

  test "returns only active compatible sources for job searches" do
    assert_equal [ sources(:two) ], searches(:one).compatible_sources.to_a
  end

  test "returns only active compatible sources for home searches" do
    assert_equal [ sources(:one) ], searches(:two).compatible_sources.to_a
  end

  test "does not mix source kinds in compatible sources" do
    sources = searches(:one).compatible_sources

    assert_not_includes sources, sources(:one)
    assert_not_includes sources, sources(:three)
  end
end
