# == Schema Information
#
# Table name: sessions
#
#  id            :integer          not null, primary key
#  session_token :string           not null
#  user_id       :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Session < ActiveRecord::Base
  validates :session_token, :user_id, presence: true
  validates :session_token, uniqueness: true

  belongs_to :user

  def self.generate_session_token
    token = SecureRandom::urlsafe_base64(16)

    while Session.exists?(session_token: token)
      token = SecureRandom::urlsafe_base64(16)
    end

    token
  end

  private

  def set_session_token
    self.session_token ||= self.class.generate_session_token
  end
end
