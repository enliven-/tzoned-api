require 'rails_helper'

RSpec.describe Timezone, type: :model do

  it 'responds to attributes name, abbr, city, gmt_difference and user' do
    timezone = Timezone.new

    expect(timezone).to respond_to(:name)
    expect(timezone).to respond_to(:abbr)
    expect(timezone).to respond_to(:city)
    expect(timezone).to respond_to(:gmt_difference)
    expect(timezone).to respond_to(:user)
  end


  it 'has valid factories' do
    timezone = FactoryGirl.build(:timezone)

    expect(timezone).to be_valid
    expect(timezone.save).to be_truthy
  end


  it 'validates presence of name, city, gmt_difference and user' do
    timezone = FactoryGirl.build(:timezone)
    
    expect(timezone).to validate_presence_of(:name)
    expect(timezone).to validate_presence_of(:abbr)
    # expect(timezone).to validate_presence_of(:city)
    expect(timezone).to validate_presence_of(:gmt_difference)
  end


  it 'validates case-insensitive uniqueness of name and abbr' do
    timezone = FactoryGirl.build(:timezone)

    expect(timezone).to validate_uniqueness_of(:name).case_insensitive
    expect(timezone).to validate_uniqueness_of(:abbr).case_insensitive
  end

end
