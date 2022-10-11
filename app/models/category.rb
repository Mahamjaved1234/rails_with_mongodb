class Category 
    include Mongoid::Document
  include Mongoid::Timestamps
  field :cat_id, type: String
  field :name, type: String
end
