# typed: false
Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  if Rails.root.join("tmp", "caching-dev.txt").exist?
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      "Cache-Control" => "public, max-age=#{2.days.to_i}",
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Store uploaded files on the local file system (see config/storage.yml for options).
  config.active_storage.service = :local

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.perform_caching = false

  # Devise
  # config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }

  # Mailcatcher
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = { :address => "escamboapp_devcontainer-mailcatcher-1", :port => 1025 }
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.default_url_options = { :host => "localhost:3000" }

  # Authorization
  config.default_password = "123456"

  config.default_permissions = ["#{Backoffice::AdminsController.controller_path}:write",
                                "#{Backoffice::AdminsController.controller_path}:read",
                                "#{Backoffice::CategoriesController.controller_path}:read",
                                "#{Backoffice::CategoriesController.controller_path}:write",
                                "#{Backoffice::MembersController.controller_path}:write",
                                "#{Backoffice::MembersController.controller_path}:read",
                                "#{Backoffice::RolesController.controller_path}:write",
                                "#{Backoffice::RolesController.controller_path}:read",
                                "#{Backoffice::PermissionsController.controller_path}:read",
                                "#{Backoffice::DashboardController.controller_path}:read",
                                "#{Backoffice::MessageController.controller_path}:write",
                                "#{Devise::SessionsController.controller_path}:write",
                                "#{Site::HomeController.controller_path}:read",
                                "#{Site::CommentsController.controller_path}:read",
                                "#{Site::CommentsController.controller_path}:write",
                                "#{Site::Profile::DashboardController.controller_path}:read",
                                "#{Site::Profile::DashboardController.controller_path}:write",
                                "#{Site::Profile::AdvertisementsController.controller_path}:read",
                                "#{Site::Profile::AdvertisementsController.controller_path}:write",
                                "#{Site::Profile::MemberProfileController.controller_path}:read",
                                "#{Site::Profile::MemberProfileController.controller_path}:write"]
  config.default_roles = [
    { name: "Administrator",
     is_admin: true,
     is_opt: false,
     is_member: false,
     permissions: ["*"],
     except_permissions: ["#{Backoffice::MembersController.controller_path}:write",
                          "#{Site::ProfileController.controller_path}"] },
    { name: "Operator",
     is_admin: false,
     is_opt: true,
     is_member: false,
     permissions: ["*"],
     except_permissions: ["#{Backoffice::AdminsController.controller_path}:write",
                          "#{Backoffice::MembersController.controller_path}:write",
                          "#{Backoffice::RolesController.controller_path}:write",
                          "#{Backoffice::PermissionsController.controller_path}:write",
                          "#{Site::ProfileController.controller_path}"] },
    { name: "Member",
      is_admin: false,
      is_opt: false,
      is_member: true,
      permissions: ["#{Site::HomeController.controller_path}:read",
                    "#{Site::Profile::DashboardController.controller_path}:read",
                    "#{Site::Profile::DashboardController.controller_path}:write",
                    "#{Site::CommentsController.controller_path}:read",
                    "#{Site::CommentsController.controller_path}:write",
                    "#{Site::Profile::MemberProfileController.controller_path}:read",
                    "#{Site::Profile::AdvertisementsController.controller_path}:read",
                    "#{Site::Profile::AdvertisementsController.controller_path}:write"],
      except_permissions: ["#{BackofficeController.controller_path}"] },
  ]

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Raises error for missing translations.
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  config.action_controller.asset_host = "localhost:3000"
end
