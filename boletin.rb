require_relative "lib/sociedad"
require_relative "lib/persona"
require_relative "lib/palabra"
require_relative "lib/model"
require_relative "lib/core_ext"

class XapianFu::XapianDocValueAccessor
  def [](key)
    value = fetch(key)

    value.is_a?(String) ? value.force_encoding(Encoding.default_external) : value
  end
end

class NilClass
  def empty?
    true
  end
end
