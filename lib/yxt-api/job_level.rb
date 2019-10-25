# frozen_string_literal: true

module Yxt
  def self.upd_grade(grades_hash)
    request 'v1/udp/sy/updgrade', datas: grades_hash
  end
end
