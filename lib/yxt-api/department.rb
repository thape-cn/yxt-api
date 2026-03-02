# frozen_string_literal: true

module Yxt
  def self.depts_sync(depts_hash)
    request 'v1/udp/public/depts/sync', depts_hash
  end
end
