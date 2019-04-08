module Yxt
  def self.sync_position(position_hash)
    request 'el/sync/position', positionInfo: position_hash.to_json.to_s
  end
end
