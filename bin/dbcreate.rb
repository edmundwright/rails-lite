require_relative '../lib/active-record-lite/db_connection'
require_relative '../db/tables.rb'

DBConnection.execute($create_script)
