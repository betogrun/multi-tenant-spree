class StoresController 
  class StoreHandler 
    def initialize(store, admin_login, admin_password)
      @store = store
      @admin_login = admin_login
      @admin_password = admin_password
    end

    def create
      StoreCreationJob.perform_now({store: @store, admin_email: @admin_login, password: @admin_password})
    end

    
  end
end