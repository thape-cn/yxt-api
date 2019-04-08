module Yxt
  def self.sync_ous(ous_hash, isBaseInfo: false)
    request 'el/sync/ous', isBaseInfo: isBaseInfo, ouInfo: ous_hash
  end
end
