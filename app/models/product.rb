# require 'csv'
class Product
    include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  field :description, type: String
  field :subcategory_id, type: String
  field :brand_id, type: String
  field :price, type: String
  field :quantity, type: String
  field :availability, type: Boolean
    # include Searchable
    # def self.import_csv!
    #     filepath = "/Users/umarmahmoodshk/products_202207281740.csv"
    #     res = CSV.parse(File.read(filepath), headers: true)
    #     res.each_with_index do |s ,ind|
    #         Product.create!(
    #             name: s["name"],
    #             price: s["price"],
    #             description: s["description"],
    #         )
    #     end
    # end


    # validates :name, :presence => true,uniqueness: true
    # validates :price, :presence => true
    # validates :description, :presence=> true
    # belongs_to :brand
end