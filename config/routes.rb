Webui::Application.routes.draw do
  root :to => 'ui#index'
  post "ui/download"
  get "ui/new"
  get "ui/index"
  get "ui/test"
end
