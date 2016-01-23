class TimezoneSerializer < ActiveModel::Serializer
  attributes :id, :name, :abbr, :gmt_difference

  def attributes
    data = super
    data[:user_id]    = object.user.id
    data[:user_email] = object.user.email
    data
  end
end
