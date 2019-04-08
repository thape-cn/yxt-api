module Yxt
  def self.sync_users(users_hash, islink: true)
    request 'el/sync/users', islink: islink, users: users_hash.to_json.to_s
  end

  def self.disable_users(user_names, isClearEmailAndMobile: false)
    request 'el/sync/disabledusers', userNames: user_names.to_json.to_s, isClearEmailAndMobile: isClearEmailAndMobile
  end

  def self.enable_users(user_names)
    request 'el/sync/enabledusers', userNames: user_names.to_json.to_s
  end

  def self.delete_users(user_names)
    request 'el/sync/deletedusers', userNames: user_names.to_json.to_s
  end

  def self.check_user(user_name)
    request 'el/sync/cku', userNames: user_name
  end
end
