class Topic < ActiveRecord::Base
  has_many :posts, dependent: :destroy
  has_many :sponsored_posts, dependent: :destroy
  has_many :labelings, as: :labelable
  has_many :labels, through: :labelings

  validates :name, length: { minimum: 5 }, presence: true
  validates :description, length: { minimum: 15 }, presence: true

  scope :visible_to, -> (user) { user ? all : Topic.publicly_viewable }
  scope :publicly_viewable, -> { where(public: true) }
  scope :privately_viewable, -> { where(public: false) }
end
