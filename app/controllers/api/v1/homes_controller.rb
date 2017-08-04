class Api::V1::HomesController < JSONAPI::ResourceController
  include Pundit::ResourceController
end
