# frozen_string_literal: true

namespace :messages do
  desc 'Subscribe to incoming sensor messages'
  task delete_old: :environment do
    Message.where('created_at > ?', 7.days.ago).delete_all
  end
end
