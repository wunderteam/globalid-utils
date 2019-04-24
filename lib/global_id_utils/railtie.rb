module GlobalIdUtils
  class Railtie < Rails::Railtie
    initializer 'global_id_utils' do |app|
      ActiveSupport.on_load(:active_record) do
        include ::GlobalIdUtils::ModelExtensions
      end
    end
  end
end
