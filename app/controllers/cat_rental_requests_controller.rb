class CatRentalRequestsController < ApplicationController
  def index

  end

  def show

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

  def edit
    @cat_rental_request = CatRentalRequest.find(params[:id])
    render :edit
  end

  private

  def cat_request_params
    params.require(:cat_rental_request).permit(:cat_id, :start_date, :end_date)
  end
end
