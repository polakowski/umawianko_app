class HexColorValidator < ActiveModel::EachValidator
  COLOR_REGEX = /\A\#([\da-f]{3}){1,2}\z/i

  def validate_each(record, attribute, value)
    return true if value.blank? || value.match(COLOR_REGEX)
    record.errors.add(:datetime, I18n.t('errors.event_type.color_invalid'))
  end
end
