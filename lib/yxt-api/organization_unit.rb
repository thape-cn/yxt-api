module Yxt
  def self.sync_ous(ous_hash)
    request 'v1/udp/sy/ous', datas: ous_hash
  end

  def self.delete_ous(ou_code_or_third_system_ids)
    request 'v1/udp/sy/deleteous', datas: ou_code_or_third_system_ids
  end

  def self.remove_users_from_ou(user_names)
    request 'v1/udp/sy/removeusersfromou', datas: user_names
  end

  def self.batch_change_org_ou(user_names, extend_key, tool_user_id)
    request 'v1/udp/sy/batchchangeorgou',
            userNames: user_names, extendKey: extend_key, toolUserId: tool_user_id
  end

  def self.get_ou_code_by_ou_name(extend_key, page_index = 1, page_size = 30)
    request 'v1/udp/sy/deptout', extendKey: extend_key, pageIndex: page_index, pageSize: page_size
  end
end
