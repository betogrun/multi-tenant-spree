class SpreeStoreCreationJob < ApplicationJob
  queue_as :default

  def perform(**args)
    # Do something later
    CreateSpreeStoreService.new(
      {
        store: args.fetch(:store),
        admin_email: args.fetch(:admin_login),
        admin_password: args.fetch(:admin_password)
      }
    ).perform

  end
end
