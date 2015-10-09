# Rails Lite

[Link to live demo app running on Rails Lite](http://rld.edmund.io)

Web server MVC framework inspired by the functionality of Ruby on Rails, containing ORM inspired by the functionality of ActiveRecord. Repository includes example app with user authentication, which can be found running online at the above link. A clean version of the repo, without the example app, can be found at the branch [here](https://github.com/edmundwright/rails-lite/tree/without-demo-app).

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

* Associations
```
belongs_to :author,
  class_name: "User",
  foreign_key: :author_id
```

## Usage

- Download clean version without demo app [here](https://github.com/edmundwright/rails-lite/archive/without-demo-app.zip).
- To make Rails Lite work with your PostgreSQL database:
  - Localhost: Add the database's name to `config/database.rb`.
  - Heroku: Rails Lite will automatically find the database's name and location. No configuration needed!
- Write SQL for creating tables in `db/tables.rb`, then run `ruby bin/dbcreate.rb`.
- Add controllers, models and views in the appropriate folders.
- Add routes in `config/routes.rb`
- To start the server:
  - Localhost: Run `ruby bin/server.rb`.
  - Heroku: Push up the repo, then run `heroku ps:scale web=1` and `heroku restart`. From then on the server will run automatically.
