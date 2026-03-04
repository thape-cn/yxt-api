# frozen_string_literal: true

module Yxt
  # https://open.yunxuetang.cn/#/document?id=1643934601388531714
  def self.positions_sync(position_hash)
    request 'v1/udp/public/positions/sync', datas: position_hash
  end
end
