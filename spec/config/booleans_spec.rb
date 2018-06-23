# frozen_string_literal: true

require 'rails_helper'

describe 'to_bool' do

  it 'returns true when like true' do
    %w{true t yes y 1}.each { |str| expect(str.to_bool).to eq(true) }
    [1, true].each { |x| expect(x.to_bool).to eq(true) }
  end

  it 'returns false when like false' do
    %w{false f no n 0}.each { |str| expect(str.to_bool).to eq(false) }
    [0, false, nil].each { |x| expect(x.to_bool).to eq(false) }
  end

  it 'raises an error when invalid' do
    expect { 'blah'.to_bool }.to raise_error(ArgumentError)
    expect { 2.to_bool }.to raise_error(ArgumentError)
  end

  it 'has to_i methods for true and false' do
    expect(true.to_i).to eq(1)
    expect(false.to_i).to eq(0)
  end

end
