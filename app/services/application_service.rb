class ApplicationService
  attr_reader :params

  def self.call(params)
    new(params).call
  end

  def initialize(params)
    @params = params
  end

  def call
    raise NotImplementedError
  end
end
