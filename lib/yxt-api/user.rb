# frozen_string_literal: true

module Yxt
  def self.users_recoversync(user_hash)
    request 'v1/udp/public/users/recoversync', user_hash
  end
end
