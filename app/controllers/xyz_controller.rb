class XyzController < ApplicationController
    skip_before_action :verify_authenticity_token
    def index
        puts " -===================== THIS ONE IS REAL ONE NOT DEVISE ONE =======================- "
        if shopper = Shopper.find_by(email:login_params[:email])
            puts "++++++++++++++++++++++++++++++++++++++#{shopper.email}++++++++++++++++++++++++"
            if shopper.password ==  login_params[:password]
                puts"---------------- YES LOGIN IS CALLED USING SHOPPER PARAMS OF #{shopper.name} ---------------" 
                Redis.current.mset("shopper_id","#{shopper.id}", "shopper_name","#{shopper.name}", "shopper_email","#{login_params[:email]}")
                puts"=======================REDIS SAVED SHOPPER ID: #{Redis.current.get("shopper_email")}===================="
                # EmailJob.perform_now(1)
                redirect_to '/addresses'
            else
                flash[:login_errors] = ['invaild credentials']
                redirect_to '/'
            end
        elsif company = Company.find_by(email:login_params[:email])
            if company.password ==  login_params[:password]
                puts"---------------- YES LOGIN IS CALLED USING COMPANY PARAMS OF #{company.id}"
                Redis.current.mset("company_id","#{company.id}", "company_name","#{company.name}", "company_email","#{login_params[:email]}")            
                puts"=======================REDIS SAVED COMPANY ID: #{Redis.current.get("company_id")}===================="            
                puts"=======================REDIS SAVED COMPANY NAME: #{Redis.current.get("company_name")} \nREDIS SAVED COMPANY EMAIL: #{Redis.current.get("company_email")} ===================="            
                # EmailJob.perform_now(1)
                redirect_to '/brands'
            else
               flash[:login_errors] = ['invaild credentials']
               redirect_to '/'
            end
        elsif retailer = Retailer.find_by(email:login_params[:email])
            if retailer.password ==  login_params[:password]
                puts"---------------- YES LOGIN IS CALLED USING RETAILER PARAMS OF #{retailer.id} ---------------"
                Redis.current.mset("retailer_id","#{retailer.id}", "retailer_name","#{retailer.name}", "retailer_email","#{login_params[:email]}")
                puts"=======================REDIS SAVED RETAILER ID: #{Redis.current.get("retailer_id")} \nREDIS SAVED RETAILER NAME: #{Redis.current.get("retailer_name")} ======================="
                # EmailJob.perform_now(1) 
                redirect_to '/orders'
            else
                puts "=========== PLEASE ENTER CORRECT CREDENTIALS ============"
                flash[:login_errors] = ['invaild credentials']
                redirect_to '/'
            end
        else
            puts "=========== PLEASE ENTER CORRECT CREDENTIALS NO USER FOUND ============"
            flash[:login_errors] = ['invaild credentials']
            redirect_to '/'
        end
        return
    end
    
    private 
     def login_params
        params.require(:login).permit(:email, :password)
     end

end
