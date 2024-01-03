class User < ApplicationRecord
  include Users::Authentication

  has_based_uuid prefix: :usr
end
