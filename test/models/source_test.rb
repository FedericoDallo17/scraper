# == Schema Information
#
# Table name: sources
#
#  id         :bigint           not null, primary key
#  active     :boolean          default(TRUE), not null
#  base_url   :string           not null
#  kind       :string           not null
#  name       :string           not null
#  slug       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_sources_on_base_url  (base_url) UNIQUE
#  index_sources_on_kind      (kind)
#  index_sources_on_name      (name) UNIQUE
#  index_sources_on_slug      (slug) UNIQUE
#
require "test_helper"

class SourceTest < ActiveSupport::TestCase
  test "requires slug" do
    source = sources(:one).dup
    source.slug = nil

    assert_not(source.valid?)
    assert_includes(source.errors[:slug], "can't be blank")
  end

  test "requires name" do
    source = sources(:one).dup
    source.name = nil

    assert_not(source.valid?)
    assert_includes(source.errors[:name], "can't be blank")
  end

  test "requires base_url" do
    source = sources(:one).dup
    source.base_url = nil

    assert_not(source.valid?)
    assert_includes(source.errors[:base_url], "can't be blank")
  end

  test "requires kind" do
    source = sources(:one).dup
    source.kind = nil

    assert_not(source.valid?)
    assert_includes(source.errors[:kind], "can't be blank")
  end

  test "enforces unique slug" do
    source = sources(:one).dup
    source.name = "Another Name"
    source.base_url = "https://another.example"

    assert_not(source.valid?)
    assert_includes(source.errors[:slug], "has already been taken")
  end

  test "enforces unique name" do
    source = sources(:one).dup
    source.slug = "another-slug"
    source.base_url = "https://another.example"

    assert_not(source.valid?)
    assert_includes(source.errors[:name], "has already been taken")
  end

  test "enforces unique base_url" do
    source = sources(:one).dup
    source.slug = "another-slug"
    source.name = "Another Name"

    assert_not(source.valid?)
    assert_includes(source.errors[:base_url], "has already been taken")
  end

  test "accepts valid kinds only" do
    assert(Source.new(slug: "jobs", name: "Jobs", base_url: "https://jobs.example", kind: "job").valid?)
    assert(Source.new(slug: "homes", name: "Homes", base_url: "https://homes.example", kind: "home").valid?)
    assert_raises(ArgumentError) do
      Source.new(slug: "other", name: "Other", base_url: "https://other.example", kind: "other")
    end
  end

  test "defaults active to true" do
    source = Source.create!(slug: "new-source", name: "New Source", base_url: "https://new.example", kind: "job")

    assert_predicate(source, :active?)
  end

  test "uses slug in routes" do
    assert_equal("mercado_libre", sources(:one).to_param)
  end
end
