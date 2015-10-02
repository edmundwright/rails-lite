$router.draw do
  get Regexp.new("^/$"), CommentsController, :index

  get Regexp.new("^/comments$"), CommentsController, :index
  get Regexp.new("^/comments/new$"), CommentsController, :new
  get Regexp.new("^/comments/(?<id>\\d+)$"), CommentsController, :show
  post Regexp.new("^/comments$"), CommentsController, :create

  get Regexp.new("^/users/new$"), UsersController, :new
  post Regexp.new("^/users$"), UsersController, :create

  get Regexp.new("^/sessions/new$"), SessionsController, :new
  post Regexp.new("^/sessions$"), SessionsController, :create
  post Regexp.new("^/sessions/destroy$"), SessionsController, :destroy

end
