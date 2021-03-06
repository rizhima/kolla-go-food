class Api::V1::FoodsController < ApplicationController
  before_action :set_food, only: [:show, :edit, :update, :destroy]
  # skip_before_action :authorize
  # GET /foods
  # GET /foods.json
  def index
    # @foods = Food.all
    @foods = Food.by_letter(params[:letter])

    if params[:term]
      @foods = Food.where('name LIKE ?', "%#{params[:name]}%")
    else
      @foods = params[:letter].nil? ? Food.all : Food.by_letter(params[:letter])
    end

    respond_to do |format|
      format.json { render json: @foods}
    end
  end

  # GET /foods/1
  # GET /foods/1.json
  def show
    respond_to do |format|
      format.json { render json: @food}
    end
  end


  # GET /foods/new
  def new
    @food = Food.new
  end

  # GET /foods/1/edit
  def edit
  end

  # POST /foods
  # POST /foods.json
  def create
    @food = Food.new(food_params)
    respond_to do |format|
      if @food.save
        format.json { render json: @food}
      else
        format.json { render json: @food.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /foods/1
  # PATCH/PUT /foods/1.json
  def update
    respond_to do |format|
      if @food.update(food_params)
        format.json { render :show, status: :ok, location: @food }
      else
        format.json { render json: @food.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /foods/1
  # DELETE /foods/1.json
  def destroy
    @food.destroy
    respond_to do |format|
      format.html { redirect_to foods_url, notice: 'Food was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_food
      @food = Food.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def food_params
      params.require(:food).permit(:name, :description, :image_url, :price, :category_id, :restaurant_id, :term, tag_ids:[])
    end
end
