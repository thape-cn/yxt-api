# frozen_string_literal: true

module Yxt
  # https://open.yunxuetang.cn/#/document?&id=1643935705069297666
  def self.positiongrades_sync(positiongrades_hash)
    request 'v1/udp/public/positiongrades/sync', positiongrades_hash
  end

  def self.positiongrades_del(thirdId)
    request "v1/udp/public/positiongrades/#{thirdId}/del", {}
  end
end
