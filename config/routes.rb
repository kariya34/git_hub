Rails.application.routes.draw do
  get 'timecard/index'

  get 'timecard/showList'

  get  '/'                        , to: 'user_authentication#index'
  post '/login/'                  , to: 'user_authentication#login'
  post '/logout/'                 , to: 'user_authentication#logout'
  post '/timecard/'               , to: 'timecard#index'
  post '/timecard/workStart'      , to: 'timecard#workStart'
  post '/timecard/workEnd'        , to: 'timecard#workEnd'
  post '/timecard/showList'       , to: 'timecard#showList'
  post '/timecard/showListPrev'   , to: 'timecard#showListPrev'
  post '/timecard/showListNext'   , to: 'timecard#showListNext'
  # post '/user_authentication/login/' , to: 'user_authentication#login'

  # get 'user_authentication/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
