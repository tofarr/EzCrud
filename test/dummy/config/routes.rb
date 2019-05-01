Rails.application.routes.draw do


  resources :comments do
    get :count, on: :collection
    get :bulk_edit, on: :collection
  end
  put :comments, to: "comments#bulk_update"
  patch :comments, to: "comments#bulk_update"


  resources :categories do
    get :count, on: :collection
    get :bulk_edit, on: :collection
  end
  put :categories, to: "categories#bulk_update"
  patch :categories, to: "categories#bulk_update"


  resources :doohickeys do
    get :count, on: :collection
    get :bulk_edit, on: :collection
  end
  put :doohickeys, to: "doohickeys#bulk_update"
  patch :doohickeys, to: "doohickeys#bulk_update"


  mount EzCrud::Engine => "/ez_crud"
end
