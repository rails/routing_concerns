require 'action_dispatch'
require 'active_support/core_ext/module/aliasing'

module ActionDispatch::Routing::Mapper::Concerns
  def concern(name, callable = nil, &block)
    callable ||= lambda { |mapper, options| mapper.instance_exec(options, &block) }
    @concerns ||= {}
    @concerns[name] = callable
  end

  def concerns(*args)
    options = args.extract_options!
    Array(args).flatten.compact.each do |name|
      if @concerns && concern = @concerns[name]
        concern.call(self, options)
      else
        raise "No concern named #{name} was found!"
      end
    end
  end
end

module ActionDispatch::Routing::Mapper::ResourcesWithConcerns
  extend ActiveSupport::Concern

  included do
    alias_method_chain :resource,  :concerns
    alias_method_chain :resources, :concerns
  end

  def resource_with_concerns(*resources, &block)
    if (options_with_concerns = resources.last).is_a?(Hash)
      named_concerns = options_with_concerns.delete(:concerns)

      resource_without_concerns(*resources) do
        concerns(named_concerns)
        block.call if block_given?
      end
    else
      resource_without_concerns(*resources, &block)
    end
  end

  def resources_with_concerns(*resources, &block)
    if (options_with_concerns = resources.last).is_a?(Hash)
      named_concerns = options_with_concerns.delete(:concerns)

      resources_without_concerns(*resources) do
        concerns(named_concerns)
        block.call if block_given?
      end
    else
      resources_without_concerns(*resources, &block)
    end
  end
end

ActionDispatch::Routing::Mapper.send :include, ActionDispatch::Routing::Mapper::Concerns
ActionDispatch::Routing::Mapper.send :include, ActionDispatch::Routing::Mapper::ResourcesWithConcerns
