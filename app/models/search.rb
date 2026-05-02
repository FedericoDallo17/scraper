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
class Search < ApplicationRecord
  delegated_type :searchable, types: %w[ JobSearch HomeSearch ], dependent: :destroy

  belongs_to :user

  def source_kind
    searchable_type.delete_suffix("Search").underscore
  end

  def compatible_sources
    Source.active.where(kind: source_kind)
  end

  validates :name, presence: true
  validates :active, presence: true, inclusion: [ true, false ]
  validates :searchable, presence: true
  validates :user, presence: true
end
