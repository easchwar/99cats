# == Schema Information
#
# Table name: cat_rental_requests
#
#  id         :integer          not null, primary key
#  cat_id     :integer          not null
#  start_date :date             not null
#  end_date   :date             not null
#  status     :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer          default("0"), not null
#

class CatRentalRequest < ActiveRecord::Base
  validates :cat_id, :start_date, :end_date, :status, :user_id, presence: true
  validate :end_date_after_start_date
  validate :no_overlapping_approved_requests

  after_initialize :set_request_to_pending

  belongs_to :cat
  belongs_to :requestor, class_name: :User, foreign_key: :user_id

  def approve!
    CatRentalRequest.transaction do
      if self.update(status: 'APPROVED')
        overlapping_pending_requests.update_all(status: 'DENIED')
      end
    end
  end

  def deny!
    self.update(status: 'DENIED')
  end

  def pending?
    self.status == 'PENDING'
  end

  private

  def set_request_to_pending
    self.status ||= 'PENDING'
  end

  def end_date_after_start_date
    unless start_date.blank? || end_date.blank?
      errors[:start_date] << "can't be after end date" if start_date > end_date
    end
  end

  def overlapping_requests
    overlap_where = <<-SQL
      start_date BETWEEN :start_date AND :end_date
      OR end_date BETWEEN :start_date AND :end_date
      OR (:start_date BETWEEN start_date AND end_date)
    SQL

    CatRentalRequest.where.not(id: id)
      .where(cat_id: cat_id)
      .where(overlap_where, start_date: start_date, end_date: end_date)
  end

  def overlapping_approved_requests
    overlapping_requests.where(status: 'APPROVED')
  end

  def overlapping_pending_requests
    overlapping_requests.where(status: 'PENDING')
  end

  def no_overlapping_approved_requests
    if overlapping_approved_requests.exists?
      errors[:base] << 'There are overlapping approved requests'
    end
  end
end
