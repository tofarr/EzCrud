Rails.application.routes.draw do
  resources :doohickeys
  mount EzCrud::Engine => "/ez_crud"
end
