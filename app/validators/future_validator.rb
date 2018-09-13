class FutureValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return true if value.blank? || value.future?
    record.errors.add(:datetime, I18n.t('errors.event.datetime_in_past'))
  end
end
