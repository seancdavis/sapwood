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

  it 'can generate a value if explicitly instructed' do
    key = Key.new(property: property_with_templates)
    expect(key.value).to eq(nil)
    key.generate_value!
    expect(key.value).to_not eq(nil)
  end

end
