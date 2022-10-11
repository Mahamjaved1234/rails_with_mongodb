class SubcategoriesController < ApplicationController
  # before_action :require_user
  before_action :set_subcategory, only: %i[ show edit update destroy ]

  # GET /subcategories or /subcategories.json
  def index
    @subcategories = Subcategory.where(category_id: Redis.current.get("category_id"))
  end

  # GET /subcategories/1 or /subcategories/1.json
  def show
  end

  # GET /subcategories/new
  def new
    @subcategory = Subcategory.new
  end

  # GET /subcategories/1/edit
  def edit
  end

  # POST /subcategories or /subcategories.json
  def create
    @subcategory = Subcategory.new(subcategory_params)

    respond_to do |format|
      if @subcategory.save
        format.html { redirect_to subcategory_url(@subcategory), notice: "Subcategory was successfully created." }
        format.json { render :show, status: :created, location: @subcategory }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @subcategory.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /subcategories/1 or /subcategories/1.json
  def update
    respond_to do |format|
      if @subcategory.update(subcategory_params)
        format.html { redirect_to subcategory_url(@subcategory), notice: "Subcategory was successfully updated." }
        format.json { render :show, status: :ok, location: @subcategory }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @subcategory.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subcategories/1 or /subcategories/1.json
  def destroy
    @subcategory.destroy

    respond_to do |format|
      format.html { redirect_to subcategories_url, notice: "Subcategory was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subcategory
      # red=Redis.current
      # @subcategory = Subcategory.find(params[:id])
      # # session[:category_id] = @category.id
      # # puts "-================= #{session[:category_id]}===============-"
      # red.set("subcategory_id","#{@subcategory.id}")
      # puts"========= REDIS SAVED SUB-CATEGORY ID #{red.get("subcategory_id")} ========="
      # @product = Product.where(subcategory_id: red.get("subcategory_id")).pluck(:name,:price,:description)

      # puts "_______________________________________________#{@product.name}-------------------------"
      # category  = Category.where(id:red.get("category_id"))


      @subcategory = Subcategory.find(params[:id])

      Redis.current.set("subcategory_id","#{@subcategory.id}")

      @product = Product.where(price:"2000")
    #  product= Product.find_by(subcategory_id:"#{@subcategory.id}")
       puts"========= REDIS SAVED SUB-CATEGORY ID #{@product.name} ========="
      puts"========= REDIS SAVED SUB-CATEGORY ID #{Redis.current.get("subcategory_id")} ========="
      category = Category.find(Redis.current.get("category_id"))
    end

    # Only allow a list of trusted parameters through.
    def subcategory_params
      params.require(:subcategory).permit(:name)
    end
end
