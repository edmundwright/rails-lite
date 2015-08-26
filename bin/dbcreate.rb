require 'sqlite3'

`rm 'db/tables.db'`
`cat 'db/create_tables.sql' | sqlite3 'db/tables.db'`
