module Yxt
  def self.sync_ous(ous_hash, isBaseInfo: false)
    request 'el/sync/ous', isBaseInfo: isBaseInfo, ouInfo: ous_hash.to_json.to_s
  end

  def self.delete_ous(ou_code_or_third_system_ids)
    request 'el/sync/deleteous', OuCodeOrThirdSystemID: ou_code_or_third_system_ids.to_json.to_s
  end

  def self.remove_user_from_all_ous(user_names)
    request 'el/sync/removeusersfromou', userNames: user_names.to_json.to_s
  end

  def self.batch_change_org_ou(new_ou_id, user_names)
    request 'el/sync/batchchangeorgou', newOuID: new_ou_id, userNames: user_names.to_json.to_s
  end

  def self.get_ou_code_by_ou_name(ou_name, islink: true)
    request 'el/sync/getoucodebyouname', islink: islink, ouname: ou_name
  end
end
