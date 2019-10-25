module Yxt
  def self.sync_users(users_hash, islink: 1, is_send_notice: 0)
    request 'v1/udp/sy/users', islink: islink, isSendNotice: is_send_notice,
                               datas: users_hash
  end

  def self.disable_users(user_names, is_clear_email_and_mobile: 0)
    request 'v1/udp/sy/disabledusers', isClearEmailAndMobile: is_clear_email_and_mobile,
                                       datas: user_names
  end

  def self.enable_users(user_names)
    request 'v1/udp/sy/enabledusers', datas: user_names
  end
end
