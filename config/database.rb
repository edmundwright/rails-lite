heroku_params_string = ENV["DATABASE_URL"]

if heroku_params_string
  match_data = heroku_params_string.match(/:\/\/(.+):(.+)@(.+):.+\/(.+)/)

  $database_params = {
    host: match_data[3],
    dbname: match_data[4],
    user: match_data[1],
    password: match_data[2]
  }
else
  $database_params = {
    # For localhost deployment, enter dbname here.
    dbname: ""
  }
end
