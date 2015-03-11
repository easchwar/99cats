# == Schema Information
#
# Table name: cats
#
#  id          :integer          not null, primary key
#  birth_date  :date             not null
#  color       :string           not null
#  name        :string           not null
#  sex         :string           not null
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer          default("0"), not null
#

class Cat < ActiveRecord::Base
  COLORS = %w( black brown orange white striped )

  validates :birth_date, :color, :name, :sex, presence: :true
  validates :sex, inclusion: { in: %w(M F) }
  validates :color, inclusion: { in: COLORS }

  belongs_to :owner, class_name: 'User', foreign_key: :user_id
  has_many :requests, class_name: 'CatRentalRequest', dependent: :destroy

  def age
    Date.today.year - birth_date.year
  end
end
