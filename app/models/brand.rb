class Brand
    include Mongoid::Document
    include Mongoid::Timestamps

    field :name, type: String
    field :slogan,  type: String
   field :company_id,  type: String
    # validates :name, :presence => true,uniqueness: true
    # validates :slogan, :presence => true,uniqueness: true
    # belongs_to :company
end
