 require 'paratrooper'

 namespace :deploy do
   desc 'Deploy app in staging environment'
   task :staging do
     deployment = Paratrooper::Deploy.new("fast-harbor-5534-staging", tag: 'staging')

     deployment.deploy
   end

   desc 'Deploy app in production environment'
   task :production do
     deployment = Paratrooper::Deploy.new("fast-harbor-5534") do |deploy|
       deploy.tag              = 'production'
       deploy.match_tag        = 'staging'
     end

     deployment.deploy
   end
 end
