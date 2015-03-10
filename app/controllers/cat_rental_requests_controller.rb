class CatRentalRequestsController < ApplicationController
  def approve
    @cat_rental_request = CatRentalRequest.find(params[:id])
      p approve_rental_url(@cat_rental_request.id)
    @cat_rental_request.approve!
    redirect_to cat_url(@cat_rental_request.cat_id)
  end
  def deny
    @cat_rental_request = CatRentalRequest.find(params[:id])
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
end
