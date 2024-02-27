=begin
Template Name: Kickoff - Tailwind CSS
Author: Andy Leverenz
Author URI: https://web-crunch.com
Instructions: $ rails new myapp -d <postgresql, mysql, sqlite3> -m template.rb
=end

def source_paths
  [File.expand_path(File.dirname(__FILE__))]
end

def add_gems
  # gem 'devise', '~> 4.8', '>= 4.8.1'
  gem 'devise', '~> 4.9', '>= 4.9.3'
  gem 'friendly_id', '~> 5.4', '>= 5.4.2'
  gem 'cssbundling-rails'
  gem 'name_of_person'
  gem 'sidekiq', '~> 6.5', '>= 6.5.4'
  gem 'stripe'
end

def add_tailwind
  rails_command "css:install:tailwind"
  # remove tailwind config that gets installed and swap for custom config
  remove_file "tailwind.config.js"
end


def add_storage_and_rich_text
  rails_command "active_storage:install"
  rails_command "action_text:install"
end

def add_users
  # Install Devise
  generate "devise:install"

  # Configure Devise
  environment "config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }",
              env: 'development'

  route "root to: 'home#index'"

  # Create Devise User
  generate :devise, "User", "first_name", "last_name", "admin:boolean"

  # set admin boolean to false by default
  in_root do
    migration = Dir.glob("db/migrate/*").max_by{ |f| File.mtime(f) }
    gsub_file migration, /:admin/, ":admin, default: false"

    #uncomment the optional fields for :confirmable, :lockable, :timeoutable, :trackable 
    # NOT included (yet) are :omniauthable, :invitable or any 2FA fields
    gsub_file migration, /# t.integer  :sign_in_count/, "t.integer  :sign_in_count"
    gsub_file migration, /# t.datetime :current_sign_in_at/, "t.datetime :current_sign_in_at"
    gsub_file migration, /# t.datetime :last_sign_in_at/, "t.datetime :last_sign_in_at"
    gsub_file migration, /# t.string   :current_sign_in_ip/, "t.string   :current_sign_in_ip"
    gsub_file migration, /# t.string   :last_sign_in_ip/, "t.string   :last_sign_in_ip"

    gsub_file migration, /# t.string   :confirmation_token/, "t.string   :confirmation_token"
    gsub_file migration, /# t.datetime :confirmed_at/, "t.datetime :confirmed_at"
    gsub_file migration, /# t.datetime :confirmation_sent_at/, "t.datetime :confirmation_sent_at"
    gsub_file migration, /# t.string   :unconfirmed_email # Only if using reconfirmable/, "t.string   :unconfirmed_email # Only if using reconfirmable"

    gsub_file migration, /# t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts/, "t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts"
    gsub_file migration, /# t.string   :unlock_token # Only if unlock strategy is :email or :both/, "t.string   :unlock_token # Only if unlock strategy is :email or :both"
    gsub_file migration, /# t.datetime :locked_at/, "t.datetime :locked_at"

    gsub_file migration, /# add_index :users, :confirmation_token,   unique: true/, "add_index :users, :confirmation_token,   unique: true"
    gsub_file migration, /# add_index :users, :unlock_token,         unique: true/, "add_index :users, :unlock_token,         unique: true"

  end

  # name_of_person gem
  append_to_file("app/models/user.rb", "\nhas_person_name\n", after: "class User < ApplicationRecord")

  # add :confirmable from the start 
  content = ":confirmable"
  insert_into_file "app/models/user.rb", ",\n\t\t\t\t\t#{content}\n", after: ":validatable"

end

def copy_templates
  directory "app", force: true
  directory "lib", force: true

  # update the routes file
  content = "resources :users"
  insert_into_file "config/routes.rb", "\n\t#{content}\n", after: "devise_for :users"
end

def add_sidekiq
  environment "config.active_job.queue_adapter = :sidekiq"

  insert_into_file "config/routes.rb",
    "require 'sidekiq/web'\n\n",
    before: "Rails.application.routes.draw do"

  content = <<-RUBY
    authenticate :user, lambda { |u| u.admin? } do
      mount Sidekiq::Web => '/sidekiq'
    end
  RUBY
  insert_into_file "config/routes.rb", "#{content}\n\n", after: "Rails.application.routes.draw do\n"
end

def add_friendly_id
  generate "friendly_id"
end

def add_tailwind_plugins
  run "yarn add -D @tailwindcss/typography @tailwindcss/forms @tailwindcss/aspect-ratio @tailwindcss/line-clamp"

  copy_file "tailwind.config.js"
end

# Main setup
source_paths

add_gems

after_bundle do
  add_tailwind
  add_tailwind_plugins
  add_storage_and_rich_text
  add_users
  add_sidekiq
  copy_templates
  add_friendly_id

  # Migrate
  rails_command "db:create"
  rails_command "db:migrate"

  git :init
  git add: "."
  git commit: %Q{ -m "Initial commit" }

  say
  say "Kickoff app successfully created! 👍", :green
  say
  say "Switch to your app by running:"
  say "$ cd #{app_name}", :yellow
  say
  say "Then run:"
  say "$ ./bin/dev", :green
end
