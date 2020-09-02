################################################################################ front_app

# cap staging front_app:deploy

after "deploy:updated", "front_app:deploy"

namespace :front_app do
  desc "静的エラーページのアップロード"
  task :deploy do
    Dir.chdir("front_app") { system "nuxt generate --dotenv .env.#{fetch(:stage)}" }

    on roles(:web) do |host|
      execute :rm, "-rf", "#{release_path}/public/s"
      upload! "front_app/dist", "#{release_path}/public/s", recursive: true
      execute :ls, "-al #{release_path}/public"
    end
  end
end
