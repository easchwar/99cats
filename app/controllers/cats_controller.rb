class CatsController < ApplicationController
  before_action :owns_cat, only: [:edit, :update]

  def index
    @cats = Cat.select('cats.*, COUNT(crr.*)')
            .joins('LEFT OUTER JOIN cat_rental_requests AS crr ON crr.cat_id = cats.id')
            .group('cats.id')
            .order('COUNT(crr.*) DESC')
    render :index
  end

  def show
    @cat = Cat.find(params[:id])
    render :show
  end

  def new
    @cat = Cat.new
    render :new
  end

  def create
    @cat = current_user.cats.new(cat_params)
    if @cat.save
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :new
    end
  end

  def edit
    render :edit
  end

  def update
    if @cat.update(cat_params)
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :edit
    end
  end

  private

  def cat_params
    params.require(:cat).permit(:name, :sex, :birth_date, :description, :color)
  end

  def owns_cat
    @cat = Cat.find(params[:id])
    unless current_user == @cat.owner
      flash[:errors] = ["Hey man, that's not your cat..."]
      redirect_to cats_url
    end
  end
end
