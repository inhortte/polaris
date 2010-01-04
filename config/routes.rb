ActionController::Routing::Routes.draw do |map|
  map.resources :photoalbums
  map.resources :photoalbums, :member => { :rearrange => :post }

  map.resources :photoalbums do |pa|
#    pa.resources :photoalbums
    pa.resources :photos
    pa.resources :photos, :member => { :download => :get }
  end

  map.resources :elizees
  map.resources :elizees, :collection => { :parse_filename => :get }

  map.resources :lepers

  map.resources :haikus
  map.resources :haikus, :member => { :toggle => :post }

  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  # map.connect '', :controller => "welcome"

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  map.connect 'blog/show_date/:year/:month/:day',
              :controller => 'blog',
              :action => 'show_date',
              :requirements => { :year => /20\d\d/,
                                 :month => /[01]?\d/,
                                 :day => /[0-3]?\d/ },
              :month => nil,
              :day => nil

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id'
end
