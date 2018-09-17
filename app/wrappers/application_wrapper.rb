class ApplicationWrapper
  def self.client_class(client)
    @@client_class = client
  end

  def initialize
    @client = @@client_class.new
  end

  def self.method_missing(method, *args)
    return instance.public_send(method, *args) if instance.respond_to?(method)
    raise Umawianko::NotImplementedError, "#{instance.class} does not implement #{method}"
  end

  def self.instance
    @@instance ||= new
  end

  private

  attr_reader :client
end
