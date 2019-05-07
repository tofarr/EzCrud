require "ez_crud/route"

Rails.application.routes.draw do

  resources :users
  EzCrud::Route.resource(self, :comments, :categories, :doohickeys, :users)

  #mount EzCrud::Engine => "/ez_crud"
end
