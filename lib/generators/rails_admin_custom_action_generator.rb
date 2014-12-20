class RailsAdminCustomActionGenerator < Rails::Generators::Base
  argument :action_name, :type => :string, :default => nil
  
  def install_plugin
    plugin_install_path = Rails.root.join('vendor', 'gems', 'rails_admin_' + action_name).to_s
    plugin_template_path = 'https://gist.githubusercontent.com/stricte/1512d6c48c590281b3af/raw/1eeab70ef6bcdc2643c92af0e1883d7116ca099a/rails_admin_action_creator'

    run("rails plugin new #{plugin_install_path} -m #{plugin_template_path} --skip-gemfile --skip-bundle -T -O -S -J --full")

    puts ""
    puts "########################################"
    puts "Remember, there are two things to do:"
    puts " - add action to rails_admin initializer"
    puts " - add action to abilities"
    puts ""
  end
end
