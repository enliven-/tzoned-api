class Timezone < ActiveRecord::Base
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :abbr, presence: true, uniqueness: { case_sensitive: false }
  validates :gmt_difference, presence: true, numericality: true

  belongs_to :user
  has_one    :city

  scope :filter, -> (term) { where("lower(name) like ?", "%#{term.downcase}%")}

  def self.load_for(user)
    user.admin? ? Timezone.all : user.timezones
  end
end
