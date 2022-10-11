class Company
    include Mongoid::Document
    include Mongoid::Timestamps

    field :name, type: String
    field :email, type: String
    field :about, type: String
   field  :password, type: String
    # validates :name,  :presence => true
    # validates :email, :presence => true,uniqueness: true
    # has_many :brands
end
