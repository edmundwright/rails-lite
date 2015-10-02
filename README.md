# Rails Lite
[Link to live demo app running on Rails Lite](http://rld.edmund.io)
Clone of Rails' basic functionality, including clone of Active Record's basic functionality. Repository includes example app with user authentication, which can be found running online at the above link.

Allows:

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
