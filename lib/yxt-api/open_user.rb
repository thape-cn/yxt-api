# frozen_string_literal: true

module Yxt
  def self.openuser_userid_encrypt(encrypt_hash)
    request 'v1/third/openuser/userid/encrypt', encrypt_hash
  end

  def self.auth_bund(bund_hash)
    request 'v2/core/public/auth/bund', bund_hash
  end
end
