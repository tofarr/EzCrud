Rails.application.routes.draw do
  resources :doohickeys do
    get :count, on: :collection
    get :bulk_edit, on: :collection
  end
  put :doohickeys, to: "doohickeys#bulk_update"
  patch :doohickeys, to: "doohickeys#bulk_update"

  mount EzCrud::Engine => "/ez_crud"
end
