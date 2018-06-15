require 'rails_helper'

RSpec.describe Key, type: :model do

  let(:key) { create(:key, property: property_with_templates) }

  it 'saves an encrypted value automatically' do
    expect(key.encrypted_value).to be_present
  end

  it 'stores the value encrypted' do
    expect(key.encrypted_value).to_not eq(key.value)
  end

  it 'can retrieve the original value from the encrypted key' do
    key.update(value: 'hello-world')
    expect(Key.first.value).to eq('hello-world')
  end

end
