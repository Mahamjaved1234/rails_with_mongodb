class UsersController < ApplicationController
  def index  
     Redis.current.flushall
    # session.destroy
    puts "================== Redis CLEARED EVERYTHING ====================="
  end
end
