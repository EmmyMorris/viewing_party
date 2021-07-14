class Party < ApplicationRecord
  belongs_to :user
  has_many :invitations, dependent: :destroy

  validates :movie_title, presence: true
  validates :duration, presence: true
  validates :date, presence: true
  validates :start_time, presence: true
  validates :external_movie_id, presence: true
end
