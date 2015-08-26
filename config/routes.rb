$router.draw do
  get Regexp.new("^/$"), DogsController, :index

  get Regexp.new("^/dogs$"), DogsController, :index
  get Regexp.new("^/dogs/new$"), DogsController, :new
  get Regexp.new("^/dogs/(?<id>\\d+)$"), DogsController, :show
  post Regexp.new("^/dogs$"), DogsController, :create

  get Regexp.new("^/users/new$"), UsersController, :new
  post Regexp.new("^/users$"), UsersController, :create

  get Regexp.new("^/sessions/new$"), SessionsController, :new
  post Regexp.new("^/sessions$"), SessionsController, :create
  post Regexp.new("^/sessions/destroy$"), SessionsController, :destroy

end
