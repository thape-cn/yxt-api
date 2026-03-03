# frozen_string_literal: true

module Yxt
  # https://open.yunxuetang.cn/#/document?&id=1643935035863560193
  def self.positioncatalogs_sync(positioncatalogs_hash)
    request 'v1/udp/public/positioncatalogs/sync', positioncatalogs_hash
  end
end
