# frozen_string_literal: true

module Yxt
  def self.positiongrades_sync(positiongrades_hash)
    request '/v1/udp/public/positiongrades/sync', positiongrades_hash
  end
end
