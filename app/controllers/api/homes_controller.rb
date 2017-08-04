class Api::HomesController < JSONAPI::ResourceController
  include Pundit::ResourceController
end
