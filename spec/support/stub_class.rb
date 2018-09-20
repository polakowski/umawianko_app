module Support
  module StubClass
    def stub_class(name, parent: nil, &block)
      if parent.nil?
        stub_const(name, Class.new(&block))
      else
        stub_const(name, Class.new(parent, &block))
      end
    end
  end
end

RSpec.configure do |config|
  config.include Support::StubClass
end
