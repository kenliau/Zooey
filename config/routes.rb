Zipreel::Application.routes.draw do
  devise_for :users

  resources 'documentations', path: 'docs'
  resources 'videos', path: 'videos'
  resources 'jobs', path: 'jobs'

  get 'admin/users' => 'admin#users'
  get 'admin/videos' => 'admin#videos'
  get 'admin/jobs' => 'admin#jobs'
  resources :admin

  get 'guide/:permalink' => 'documentations#show_by_permalink'

  root :to => 'static#index'

  match ':action' => 'static#:action'
  match '/upload', to: 'static#upload'
  match '/how_it_works', to: 'static#how_it_works'
end
