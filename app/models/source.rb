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
class Source < ApplicationRecord
  enum :kind, { job: "job", home: "home" }

  scope :active, -> { where(active: true) }

  validates :active, presence: true, inclusion: [ true, false ]
  validates :base_url, presence: true
  validates :base_url, uniqueness: true
  validates :kind, presence: true, inclusion: { in: kinds.keys }
  validates :name, presence: true
  validates :name, uniqueness: true
  validates :slug, presence: true
  validates :slug, uniqueness: true

  def to_param
    slug
  end
end
