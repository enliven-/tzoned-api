class Timezone < ActiveRecord::Base
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :abbr, presence: true, uniqueness: { case_sensitive: false }
  validates :gmt_difference, presence: true


  belongs_to :user
  has_one    :city

end
