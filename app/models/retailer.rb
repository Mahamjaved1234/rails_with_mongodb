class Retailer 
    include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :email, type: String
  field :password, type: String
  field :phone, type: String
  field :address, type: String
end
