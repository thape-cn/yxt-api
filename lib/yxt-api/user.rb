module Yxt
  def self.sync_users(users_hash, islink: false)
    request 'el/sync/users', islink: islink, users: users_hash.to_json.to_s
  end
end
