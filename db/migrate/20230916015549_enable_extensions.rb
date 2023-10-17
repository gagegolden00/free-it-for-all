class EnableExtensions < ActiveRecord::Migration[7.0]
  def up
    execute 'CREATE EXTENSION IF NOT EXISTS pg_stat_statements'
    execute 'CREATE EXTENSION IF NOT EXISTS citext'
    execute 'CREATE EXTENSION IF NOT EXISTS intarray'
    execute 'CREATE EXTENSION IF NOT EXISTS pg_trgm'
  end

  def down
    execute 'DROP EXTENSION pg_stat_statements'
    execute 'DROP EXTENSION citext'
    execute 'DROP EXTENSION intarray'
    execute 'DROP EXTENSION pg_trgm'
  end
end
