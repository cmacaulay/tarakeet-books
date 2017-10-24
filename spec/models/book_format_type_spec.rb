require 'rails_helper'

RSpec.describe BookFormatType, type: :model do
  context "validations" do
    it { should validate_presence_of(:name) }
  end

  context "relationships" do
    it {should have_many(:book_formats) }
    it { should have_many(:books).through(:book_formats) }
  end

  it "has a valid factory" do
    book_format = FactoryBot.create(:book_format_type)
    expect(book_format).to be_valid
  end

  it "is not valid without a name" do
    book_format = BookFormatType.new(physical: false)
    expect(book_format).to_not be_valid
  end

  it "is is valid with both fields" do
    book_format = BookFormatType.new(name: "PDF", physical: false)

    expect(book_format).to be_valid
  end
end
