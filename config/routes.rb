Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#index'
  scope '/charges' do
    post 'simple', to: 'charges#simple', as: 'simple_charge'
  end
end
