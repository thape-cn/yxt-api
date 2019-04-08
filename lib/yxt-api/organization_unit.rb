module Yxt
  def self.sync_ous(ous_hash, isBaseInfo: false)
    request 'el/sync/ous', isBaseInfo: isBaseInfo, ouInfo: ous_hash.to_json.to_s
  end
end
