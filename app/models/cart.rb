class Cart 

    include Mongoid::Document
    include Mongoid::Timestamps
     
    field :shopper_id, type: String
    field :product_id, type: String
    field :total, type: Integer
    field :qty, type: Integer
    field :products, type: String
end
