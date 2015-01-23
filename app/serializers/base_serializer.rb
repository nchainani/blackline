class BaseSerializer < ActiveModel::Serializer
  def self.protected_attributes(*attrs)
    @protected_attributes = attrs
  end

  def initialize(object, options = {})
    @protected = options.fetch(:protected, false)
    super
  end

  def attributes
    hash = super
    if @protected
      attrs = self.class.instance_variable_get(:@protected_attributes)
      Array(attrs).each do |name|
        hash[name] = object.send(name)
      end
    end
    hash
  end
end