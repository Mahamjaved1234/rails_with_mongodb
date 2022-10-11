class Shopper 
    include Mongoid::Document
    include Mongoid::Timestamps
    field :name, type: String
    field :email, type: String
    field :password, type: String
    field :phone, type: String
    field :shopper_addresss, type: String
end
