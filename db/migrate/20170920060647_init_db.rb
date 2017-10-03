class InitDb < ActiveRecord::Migration[5.0]
  def change

    enable_extension "plpgsql"
    enable_extension 'uuid-ossp'

  end
end
