Rails.application.routes.draw do

  get  '/'                        , to: 'user_authentication#index'
  post '/login/'                  , to: 'user_authentication#login'
  post '/logout/'                 , to: 'user_authentication#logout'
  get  '/timecard/'               , to: 'timecard#index'
  post '/timecard/'               , to: 'timecard#index'
  post '/timecard/workStart'      , to: 'timecard#workStart'
  post '/timecard/workEnd'        , to: 'timecard#workEnd'
  post '/work_history/'           , to: 'work_history#index'
  post '/work_history/prev'       , to: 'work_history#prev'
  post '/work_history/next'       , to: 'work_history#next'
end
