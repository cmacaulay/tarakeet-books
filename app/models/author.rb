class Author < ApplicationRecord
  validates_presence_of :first_name,
                        :last_name
end
