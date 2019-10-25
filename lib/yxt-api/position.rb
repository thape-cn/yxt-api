module Yxt
  def self.sync_position(position_hash)
    request 'v1/udp/sy/position', datas: position_hash
  end

  def self.sync_position_for_no_pno(position_hash)
    request 'el/sync/positionfornopno', positionInfo: position_hash.to_json.to_s
  end

  def self.update_position_name(position_no, position_name)
    request 'el/sync/updatepositioninfo', positionNo: position_no, positionName: position_name
  end
end
