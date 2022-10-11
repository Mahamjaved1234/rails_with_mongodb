class Order 
    include Mongoid::Document
  include Mongoid::Timestamps
  field :retailer_id, type: String
  field :status, type: Boolean
  field :products, type: String
  field :shopper_address, type: String
  field :shopper_id, type: String
  field :grand_total, type: Integer
end
