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
#

class CatRentalRequest < ActiveRecord::Base
  validates :cat_id, :start_date, :end_date, :status, presence: true
  validate :end_date_after_start_date
  validate :no_overlapping_approved_requests

  after_initialize :set_request_to_pending

  belongs_to :cat

  private

  def set_request_to_pending
    self.status ||= 'PENDING'
  end

  def end_date_after_start_date
    if start_date > end_date
      errors[:start_date] << "can't be after end date"
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

  def no_overlapping_approved_requests
    if overlapping_approved_requests.exists?
      errors[:base] << 'There are overlapping approved requests'
    end
  end

end
