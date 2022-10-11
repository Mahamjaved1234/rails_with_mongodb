class AddressesController < ApplicationController
  # before_action :require_user
  before_action :set_address, only: %i[ show edit update destroy ]

  # GET /addresses or /addresses.json
  def index
    @addresses = Address.where(shopper_id: Redis.current.get("shopper_id")).pluck(:id, :name)
    # url = "http://localhost:3000/api/v1/addresses/ShopperAddr?shopper_id=#{Redis.current.get("shopper_id")}"
    # response = 
  end

  # GET /addresses/1 or /addresses/1.json
  def show
  end

  # GET /addresses/new
  def new
    @address = Address.new
  end

  # GET /addresses/1/edit
  def edit
  end

  # POST /addresses or /addresses.json
  def create
    @address = Address.new(address_params)
    @address.shopper_id =Redis.current.get("shopper_id")
    respond_to do |format|
      if @address.save
        format.html { redirect_to address_url(@address), notice: "Address was successfully created." }
        format.json { render :show, status: :created, location: @address }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @address.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /addresses/1 or /addresses/1.json
  def update
    respond_to do |format|
      if @address.update(address_params)
        format.html { redirect_to address_url(@address), notice: "Address was successfully updated." }
        format.json { render :show, status: :ok, location: @address }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @address.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /addresses/1 or /addresses/1.json
  def destroy
    @address.destroy
    respond_to do |format|
      format.html { redirect_to addresses_url, notice: "Address was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_address
      address = Address.find_by(id: params[:id])
      if (address.shopper_id) == Redis.current.get("shopper_id")
        flash[:notice] = "You must be the same user as this address."
        Redis.current.mset("address_id","#{address.id}","address_name","#{address.name}","address_detail","#{address.detail}")
      puts "~~~~~~~~~~~~~~~~~~~~~ REDIS SAVED ADDRESS INFO #{address.detail }~~~~~~~~~~~~~~~~~~~~~"
      @retailers = Retailer.all
        # redirect_to '/addresses'
      end
      Redis.current.mset("address_id","#{address.id}","address_name","#{address.name}","address_detail","#{address.detail}")
      puts "~~~~~~~~~~~~~~~~~~~~~ REDIS SAVED ADDRESS INFO #{address.detail }~~~~~~~~~~~~~~~~~~~~~"
      @retailers = Retailer.all
    end

    # Only allow a list of trusted parameters through.
    def address_params
      params.require(:address).permit(:name, :detail)
    end
   

end
