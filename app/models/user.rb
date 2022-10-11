class User
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  include Mongoid::Document
  include Mongoid::Timestamps
  # devise :database_authenticatable, :registerable,
  #        :recoverable, :rememberable, :validatable
end
