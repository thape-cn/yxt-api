# frozen_string_literal: true

require 'yxt-api'

RSpec.describe Yxt do
  describe '.openuser_userid_encrypt' do
    it 'requests the open user userid encrypt endpoint' do
      payload = {
        userIds: ['zhangsan'],
        type: 0,
        agentId: '123',
        corpId: 'corp'
      }

      expect(described_class).to receive(:request)
        .with('v1/third/openuser/userid/encrypt', payload)

      described_class.openuser_userid_encrypt(payload)
    end
  end

  describe '.auth_bund' do
    it 'requests the auth bund endpoint' do
      payload = {
        agentId: '123',
        openId: 'encrypted-userid',
        type: 1,
        userId: 'ca49537c-x2cf-4x09-8335-1cxxx26a60a'
      }

      expect(described_class).to receive(:request)
        .with('v2/core/public/auth/bund', payload)

      described_class.auth_bund(payload)
    end
  end
end
