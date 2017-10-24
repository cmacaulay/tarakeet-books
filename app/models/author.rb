class Author < ApplicationRecord
  validates_presence_of :first_name,
                        :last_name

  has_many :books

  def format_name
    "#{last_name}, #{first_name}"
  end
end
