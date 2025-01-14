class Party < ApplicationRecord
  belongs_to :user
  has_many :invitations, dependent: :destroy

  validates :movie_title, presence: true
  validates :duration, presence: true
  validates :starts_at, presence: true
  validates :external_movie_id, presence: true
  validate :date_is_valid?

  def date_is_valid?
    return if starts_at.blank?

    error_msg = 'Error: Party must be set for a future date'
    errors.add(:date, error_msg) if starts_at < Time.zone.now
  end

  def send_invitations
    friends = invitations.map { |invitation| User.find(invitation.user_id) }
    friends.each do |friend|
      InvitationMailer.invite(host, friend, self).deliver_now
    end
  end

  def starts_at_date
    starts_at&.strftime('%m/%d/%Y')
  end

  def starts_at_time
    starts_at&.strftime('%H:%M')
  end

  def host
    User.find(user_id)
  end
end
