class GlobalIdValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    URI::GID.parse(value)
  rescue URI::Error
    record.errors.add(attribute, options.fetch(:message, 'is not a valid URI::GID'))
  end
end
