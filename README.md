# Rails Lite

[Link to live demo app running on Rails Lite](http://rld.edmund.io)

Clone of Rails' basic functionality, including clone of Active Record's basic functionality. Repository includes example app with user authentication, which can be found running online at the above link.

## Features

* Mutually stackable and lazy ActiveRecord like methods

```
cats = Cat.joins(:human, :house).where("fname = ?", "Ned").where(address: "26 Main Street")
```

* The Flash

```
flash[:notice] = "Thanks for signing up!"
flash.now[:errors] = @user.errors
```

* Some validations

```
validates :username, presence: true
validates :password, length: { minimum: 6, allow_nil: true }
```

* CSRF protection
```
class ApplicationController < ControllerBase
  protect_from_forgery
  ...

<form action="/sessions" method="post">
  <input type="hidden" name="authenticity_token" value="<%= form_authenticity_token %>">
  ...
```

## Usage

- Download clean version without demo app [here](https://github.com/edmundwright/rails-lite/archive/without-demo-app.zip).
- Create a Postgres database, and if running locally add its name to `config/database.rb`. If running on Heroku, add the Postgres add-on, and Rails Lite will automatically find the database's name and location.
- Write SQL for creating tables in `db/tables.rb`, then run `ruby bin/dbcreate.rb`.
- Add controllers, models and views in the appropriate folders.
- Add routes in `config/routes.rb`
- Run `ruby bin/server.rb` to start the server on localhost. For Heroku, push up the repo, then run `heroku ps:scale web=1` and `heroku restart`. From now on the server will run automatically.
