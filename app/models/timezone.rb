class Timezone < ActiveRecord::Base
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :abbr, presence: true, uniqueness: { case_sensitive: false }
  validates :city, presence: true, uniqueness: { case_sensitive: false }
  validates :gmt_difference, presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: -43200, less_than_or_equal_to: 43200 }

  belongs_to :user

  scope :filter, -> (term) { where("lower(name) like ?", "%#{term.downcase}%")}

  def self.load_for(user)
    user.admin? ? Timezone.all : user.timezones
  end
end
