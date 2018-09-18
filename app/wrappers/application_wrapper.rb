class ApplicationWrapper
  def initialize
    @client = @@client_class.new
  end

  class << self
    def client_class(klass_name)
      @@client_class = klass_name
    end

    def forward(*methods)
      methods.each do |method|
        class_eval <<-CODE, __FILE__, __LINE__ + 1
          def self.#{method}(*args); new.#{method}(*args); end
        CODE
      end
    end
  end

  private

  attr_reader :client
end
