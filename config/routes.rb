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
  get 'guide' => redirect('/docs/1')

  root :to => 'static#index'

  match ':action' => 'static#:action'
  match '/upload', to: 'static#upload'
  match '/how_it_works', to: 'static#how_it_works'

  get 'jobs/progression/:job_id' => 'progressions#show_by_job_id'
  put 'jobs/progression/:job_id' => 'progressions#update_by_job_id'
end
