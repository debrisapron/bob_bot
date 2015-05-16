class User < ActiveRecord::Base

  def name
    new_record? ? nil : "User#{ id }"
  end

end