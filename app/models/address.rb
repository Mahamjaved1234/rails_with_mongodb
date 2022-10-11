class Address
    include Mongoid::Document
    include Mongoid::Timestamps
  
  
    field :detail, type: String
    field :name, type: String
    field :shopper_id, type: String
    field :shopper_address, type: String
      belongs_to :shopper 
end
