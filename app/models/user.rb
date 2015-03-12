# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  user_name       :string           not null
#  password_digest :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ActiveRecord::Base
  attr_reader :password

  validates :user_name, presence: true
  validates :user_name, uniqueness: true
  validates :password, length: { minimum: 6, allow_nil: true }

  has_many :cats, dependent: :destroy
  has_many :cat_rental_requests, dependent: :destroy
  has_many :sessions

  def self.find_by_credentials(user_name, password)
    @user = User.find_by_user_name(user_name)
    if @user
      @user.is_password?(password) ? @user : nil
    else
      nil
    end
  end


  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

end
