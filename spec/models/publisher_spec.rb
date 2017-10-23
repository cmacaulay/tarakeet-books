require 'rails_helper'

RSpec.describe Publisher, type: :model do
  context "validations" do
    it {should validate_presence_of(:name) }
    it {should validate_uniqueness_of(:name) }
  end

  it "has a valid factory" do
    publisher = FactoryBot.create(:publisher)
    expect(publisher).to be_valid
  end

  it "is not valid without a name" do
    publisher = Publisher.new(name: nil)
    expect(publisher).to_not be_valid
  end

  it "is valid with a name" do
    publisher = Publisher.new(name: "New Publisher")
    expect(publisher).to be_valid
  end

end
