Rails.application.routes.draw do

  post 'rfid_data', to: 'rfids#create'
end
