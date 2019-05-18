require "ez_crud/route"

Rails.application.routes.draw do

  EzCrud::Route.resource(self, :comments, :categories, :doohickeys, :users, :restricteds)

  #mount EzCrud::Engine => "/ez_crud"
end
