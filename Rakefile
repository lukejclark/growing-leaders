namespace :assets do
  task :precompile do
    sh 'middleman build'
  end
end

#########################################################################################################

namespace :ff do
  task :setup do
    if !ENV['RACK_ENV'] or ENV['RACK_ENV'] == 'development'
      `powify create growingleadersforgeorgia`; puts "- growingleadersforgeorgia.gg powified"
    else
      puts "no setup task for #{ENV['RACK_ENV']} environment"
    end
  end
end

#########################################################################################################

