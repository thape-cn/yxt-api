# frozen_string_literal: true

module Yxt
  def self.sync_position(position_hash)
    request 'v1/udp/sy/position', datas: position_hash
  end

  def self.update_position_info(position_no, position_name)
    request 'v1/udp/sy/updatepositioninfo', positionNo: position_no, positionName: position_name
  end
end
