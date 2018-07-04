# frozen_string_literal: true

ActiveRecord::Base.transaction do
  # create our super user
  Role.create! name: 'janitor', friendly_name: 'System janitor'
end
