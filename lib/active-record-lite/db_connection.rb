require 'pg'
require_relative '../../config/database'

class DBConnection
  def self.reset
    # @db = PG.connect(dbname: DB_NAME)
    @db = PG.connect($database_params)

    @db
  end

  def self.instance
    @db || reset
  end

  def self.execute(*args)
    args[0] = transform_question_marks(args[0])
    p args[0]
    p args.drop(1)
    instance.exec_params(*args)
  end

  def self.last_insert_row_id
    instance.last_insert_row_id
  end

  def self.transform_question_marks(fragment)
    counter = 1

    while true
      new_fragment = fragment.sub("?", "$#{counter}")
      if new_fragment == fragment
        break
      else
        counter += 1
        fragment = new_fragment
      end
    end

    new_fragment
  end
end
# @db.results_as_hash = true
# @db.type_translation = true
