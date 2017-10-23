require 'rails_helper'

RSpec.describe Author, type: :model do
  context "validations" do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
  end
  it "has a valid factory" do
    author = FactoryBot.create(:author)
    expect(author).to be_valid
  end
  it "is not valid without a first name" do
    author = Author.new(first_name: nil,
                        last_name: "Huxley")
    expect(author).to_not be_valid
  end

  it "is not valid without a last name" do
    author = Author.new(first_name: "Aldous",
                        last_name: nil)
    expect(author).to_not be_valid
  end
  it "is valid with both a first and last name" do
    author = Author.new(first_name: "Aldous",
                        last_name: "Huxley")
    expect(author).to be_valid
  end
end
