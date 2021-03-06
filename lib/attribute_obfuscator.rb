# frozen_string_literal: true

class AttributeObfuscator
  def self.name_hint(name)
    name = name.to_s

    return nil if name.blank?
    return obfuscate(0, 0, name) if name.length < 3
    return obfuscate(1, 1, name) if name.length < 5

    obfuscate(3, 3, name)
  end

  # This is the default obfuscator for the authorizations log, so
  # let's be conservative with obfuscation
  def self.secret_attribute_hint(value)
    value = value.to_s

    return nil if value.blank?
    return "*" * value.length if value.length < 5

    "#{value.first}#{"*" * (value.length - 2)}#{value.last}"
  end

  def self.obfuscate(plain_start_size, plan_end_size, value)
    obfuscated_length = value.length - plain_start_size - plan_end_size

    plain_start = plain_start_size.zero? ? "" : value[0..plain_start_size - 1]
    obfuscated = "*" * obfuscated_length
    plain_end = plan_end_size.zero? ? "" : value[-plan_end_size..value.length]

    "#{plain_start}#{obfuscated}#{plain_end}"
  end
  private_class_method :obfuscate
end
