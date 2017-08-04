module Api
  class ApplicationResource < JSONAPI::Resource
    include Pundit::Resource
    immutable
  end
end
