class TimezoneSerializer < ActiveModel::Serializer
  attributes :id, :name, :abbr, :gmt_difference
end
