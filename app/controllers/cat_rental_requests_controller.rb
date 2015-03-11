class CatRentalRequestsController < ApplicationController
  before_action :owns_cat, only: [:approve, :deny]

  def approve
    @cat_rental_request.approve!
    redirect_to cat_url(@cat_rental_request.cat_id)
  end

  def deny
    @cat_rental_request.deny!
    redirect_to cat_url(@cat_rental_request.cat_id)
  end

  def new
    @cats = Cat.all
    @cat_rental_request = CatRentalRequest.new
    render :new
  end

  def create
    @cats = Cat.all
    @cat_rental_request = CatRentalRequest.new(cat_request_params)

    if @cat_rental_request.save
      redirect_to cat_url(@cat_rental_request.cat_id)
    else
      flash.now[:errors] = @cat_rental_request.errors.full_messages
      render :new
    end
  end

  private

  def cat_request_params
    params.require(:cat_rental_request).permit(:cat_id, :start_date, :end_date)
  end

  def owns_cat
    @cat_rental_request = CatRentalRequest.find(params[:id])
    unless current_user == @cat_rental_request.cat.owner
      flash[:errors] = ["Hey man, that's not your cat..."]
      redirect_to cat_url(@cat_rental_request.cat)
    end
  end
end
