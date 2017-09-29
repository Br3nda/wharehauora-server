namespace :messages do
  desc 'Subscribe to incoming sensor messages'
  task delete_old: :environment do
    Messages.where('created_at > ?', 7.days.ago).delete_all
  end
end
