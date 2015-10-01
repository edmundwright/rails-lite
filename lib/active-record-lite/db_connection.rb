require 'pg'

DB_NAME = 'rails_lite_app'

class DBConnection
  def self.reset
    p "Resetting connection to #{DB_NAME}..."
    @db = PG.connect(dbname: DB_NAME)

    @db
  end

  def self.instance
    @db || reset
  end

  def self.execute(*args)
    instance.exec_params(*args)
  end

  def self.last_insert_row_id
    instance.last_insert_row_id
  end
end
# @db.results_as_hash = true
# @db.type_translation = true
