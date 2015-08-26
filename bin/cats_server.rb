require 'active_support'
require 'active_support/core_ext'
require 'webrick'
require_relative '../lib/controller_base'
require 'byebug'

# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/HTTPRequest.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/HTTPResponse.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/Cookie.html

class Cat
  attr_reader :name, :owner, :errors

  def self.all
    @cat ||= []
  end

  def initialize(params = {})
    params ||= {}
    @name, @owner = params["name"], params["owner"]
    @errors = []
  end

  def save
    errors << "Name must be present" unless @name.present?
    errors << "Owner must be present" unless @owner.present?
    return false unless @name.present? && @owner.present?

    Cat.all << self
    true
  end

  def inspect
    { name: name, owner: owner }.inspect
  end
end

class ApplicationController < ControllerBase
  protect_from_forgery
end

class CatsController < ApplicationController
  def create
    @cat = Cat.new(params["cat"])
    if @cat.save
      flash[:notice] = "Thanks for adding a cat!"
      redirect_to("/cats")
    else
      flash.now[:errors] = @cat.errors
      render :new
    end
  end

  def index
    @cats = Cat.all
    render :index
  end

  def new
    @cat = Cat.new
    render :new
  end

  def bad_new
    p self.class.protected_from_forgery?
    @cat = Cat.new
    render :bad_new
  end
end

router = Router.new
router.draw do
  get Regexp.new("^/cats$"), CatsController, :index
  get Regexp.new("^/cats/new$"), CatsController, :new
  get Regexp.new("^/cats/bad_new$"), CatsController, :bad_new
  post Regexp.new("^/cats$"), CatsController, :create
end

server = WEBrick::HTTPServer.new(Port: 3000)
server.mount_proc('/') do |req, res|
  route = router.run(req, res)
end

# server = WEBrick::HTTPServer.new(Port: 3000)
# server.mount_proc('/') do |req, res|
#   case [req.request_method, req.path]
#   when ['GET', '/cats']
#     CatsController.new(req, res, {}).index
#   when ['POST', '/cats']
#     CatsController.new(req, res, {}).create
#   when ['GET', '/cats/new']
#     CatsController.new(req, res, {}).new
#   end
# end

trap('INT') { server.shutdown }
server.start
