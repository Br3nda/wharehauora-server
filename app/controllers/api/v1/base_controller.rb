class Api::V1::BaseController < JSONAPI::ResourceController
  include Pundit::ResourceController
end
