class Subcategory 
    include Mongoid::Document
    include Mongoid::Timestamps
    field :name, type: String
    field :category_id, type: String
    belongs_to :category
end
