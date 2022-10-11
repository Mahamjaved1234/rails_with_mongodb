class ProductsController < ApplicationController
  # before_action :require_user
  before_action :set_product, only: %i[ show edit update destroy ]
  # GET companies/id?/products or /companies/id?/products.json
 def search
  query = params[:search_products].presence && params[:search_products][:query]

if query
  @products = Product.search_published(query)
end
 end
 
  def index
   @brand = Brand.where(company_id: Redis.current.get("company_id"))
  #  @products = Product.where(brand_id: Redis.current.get("brand_id"))
  @prod = Product.new(name: "Fake", description: "Fake Description", price:99, quantity: 100, availability: true, brand_id: 99,subcategory_id: 99)
  @prod.save
  @products= Product.all
   respond_to do |format|
       format.html  # index.html.erb
       format.json  { render :json => @products }
   end
      # $i = 0;
      # while @brand[$i] != nil
      #   $t_id = @brand[$i].id.to_i
      #   puts "My name is #{@brand[$i].name}"
      #   @products = Product.where(brand_id: @brand[$i].id)
      #   $i +=1;
      # end
    #   query = params["query"] || ""
    #   res = Product.search(query)
    #   puts "=============== #{res.response.hits}================="
    #  render json: res.response["hits"]["hits"]
  end
  # GET /companies/id?/products/1 or /companies/id?/products/1.json
  def show
    storage = Google::Cloud::Storage.new(
      project_id: "your project id",
    credentials: "keyfile.json"
    )
    bucket = storage.bucket "project_id.com"
    
   
      @product = Product.find(params[:id])
      if (file = bucket.file "#{@product.id}.jpg")
        @url = "link to photo#{@product.id}.jpg?alt=media"
      else
        @url = "default photo link"
      end
  end
  def new
      @product = Product.new
      puts "#{@product}"
      respond_to do |format|
        format.html  # new.html.erb
        format.json  { render :json => @product }
      end
  end
  # POST /products/new
  def create
      @product = Product.new(product_params)
      # @product[:brand_id] = 99
      @product.brand_id =  Redis.current.get("brand_id")
      $val = @product.availability
      # @product.availability = $val.to_b
      respond_to do |format|
          if @product.save
            file_data = product_params_image[:image].tempfile.path
    storage = Google::Cloud::Storage.new(
      project_id: "your project id",
      credentials: "keyfile.json"
     )
    
     bucket = storage.bucket "your project id.com"
    
    file = bucket.create_file file_data , "#{@product.id}.jpg"
              format.html { redirect_to product_url(@product), notice: "Product was successfully created." }
              format.json { render :show, status: :created, location: @product }
          else
              format.html { render :new, status: :unprocessable_entity }
              format.json { render json: @product.errors, status: :unprocessable_entity }
          end

         
      end
    end

    # GET /companies/id?/products/1/edit
def edit
  @product = Product.find(params[:id])
end
# PATCH/PUT /companies/id?/products/1 or /companies/id?/products/1.json
def update
  if(Redis.current.get("shopper_id") == nil)
    puts"-==========COMPANY IS LOGGED IN =============-"
    respond_to do |format|
      if @product.update(product_params)
        file_data = product_params_image[:image].tempfile.path
        storage = Google::Cloud::Storage.new(
          project_id: "your project_id",
          credentials: "keyfile.json"
        )
        bucket = storage.bucket "your project_id.com"
    
        file = bucket.create_file file_data , "#{@product.id}.jpg"
        format.html { redirect_to product_url(@product), notice: "Product was updated successfully." }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
      return 
    end
  else
    puts"-++++++++++USER IS LOGGED IN #{Redis.current.get("shopper_id")}++++++++++++-"
    prod_qty=product_params[:quantity]
    @cart = Cart.where(shopper_id: Redis.current.get("shopper_id")).first
    if (@cart == nil)
      puts "Cart not found creating New cart"  
      @cart=Cart.new
      @cart.qty = prod_qty.to_i  
      @product = Product.find(params[:id])  
      @cart.total = (@product.price).to_i * prod_qty.to_i
      Redis.current.set("cart_#{@cart.id}_total","#{@cart.total}")
      Redis.current.set("cart_id","#{@cart.id}")
      @cart.shopper_id= Redis.current.get("shopper_id")
      prod = [
        {
          "product_id" => "#{@product.id}",
          "product_name" => "#{@product.name}",
          "product_qty" => "#{prod_qty.to_i}",  
          "product_total" => "#{(@product.price).to_i * prod_qty.to_i}",  
          "retailer_id" => "#{Redis.current.get("retailer_id")}",  
          "status" => "false"  
        }  
      ].to_json  
      @cart.products = prod
      @cart.save  
      puts "-=========PRODUCT IN CART AS: #{@cart.products}==========-"
      respond_to do |format|  
        if @cart.save  
          format.html { redirect_to cart_url(@cart), notice: "Added to cart" }
          format.json { render :show, status: :created, location: @cart }  
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @cart.errors, status: :unprocessable_entity }
        end
      end 
    else  
      puts "Cart already exists"  
      @cart.qty += prod_qty.to_i  
      @product = Product.find(params[:id])  
      @prod_total = (@product.price).to_i * prod_qty.to_i  
      @cart.total += @prod_total  
      Redis.current.set("cart_#{@cart.id}_total","#{@cart.total}")  
      prod = @cart.products + [  
        {  
          "product_id" => "#{@product.id}",  
          "product_name" => "#{@product.name}",  
          "product_qty" => "#{prod_qty.to_i}",  
          "product_total" => "#{@product.price * prod_qty.to_i}",  
          "retailer_id" => "#{Redis.current.get("retailer_id")}",  
          "status" => "false"  
        }  
      ].to_json  
      @cart.products = prod    
      @cart.save
      puts "-=========PRODUCT IN CART AS: #{@cart.products}==========-"
      respond_to do |format|  
        if @cart.save  
          format.html { redirect_to cart_url(@cart), notice: "Added to cart" }
          format.json { render :show, status: :created, location: @cart }  
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @cart.errors, status: :unprocessable_entity }
        end
      end   
    end
  end
end



# DELETE /companies/id?/products/1 or /companies/id?/products/1.json
def destroy
  @product.destroy
  respond_to do |format|
    format.html { redirect_to products_url, notice: "Product was successfully destroyed." }
    format.json { head :no_content }
  end
end
private
  # Use callbacks to share common setup or constraints between actions.
  def set_product
    @product = Product.find(params[:id])
    @brand = Brand.find(@product.brand_id)
    @company = Company.find(@brand.company_id)
    Redis.current.set("product_id","#{@product.id}")
    puts"========= REDIS SAVED PRODUCT ID #{Redis.current.get("product_id")} ========="
    Redis.current.set("company_id","#{@company.id}")
    puts"========= REDIS SAVED COMPANY ID #{Redis.current.get("company_id")} ========="
  end
  # Only allow a list of trusted parameters through.
  def product_params_image
    params.require(:product).permit(:name, :description, :price, :brand_id, :availability, :quantity, :subcategory , :image)
  end
  def product_params
    params.require(:product).permit(:name, :description, :price, :brand_id, :availability, :quantity, :subcategory)
  end
end
