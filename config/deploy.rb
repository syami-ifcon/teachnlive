set :application, "deploy_test"
set :repo_url, "git@github.com:syami-ifcon/teachnlive.git"

set :deploy_to, '/home/deploy_test'

set :rbenv_type, :user
set :rbenv_ruby, '2.5.1'

append :linked_files, "config/database.yml", "config/secrets.yml"
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "vendor/bundle", "public/system", "public/uploads"