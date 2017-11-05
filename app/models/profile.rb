class Profile < ApplicationRecord
  include ImageUploader[:image]
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :title, presence: true
  validates :about, presence: true
end
