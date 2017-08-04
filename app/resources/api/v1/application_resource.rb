module Api
  module V1
    class ApplicationResource < JSONAPI::Resource
      include Pundit::Resource
      immutable
    end
  end
end
