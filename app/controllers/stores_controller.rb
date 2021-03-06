class StoresController < ApplicationController
  before_action :set_store, only: [:show, :edit, :update, :destroy]
    before_action :authenticate_seller!

  # GET /stores
  # GET /stores.json
  def index
    @stores = current_seller.stores
  end

  # GET /stores/1
  # GET /stores/1.json
  def show
  end

  # GET /stores/new
  def new
    @store = Store.new
  end

  # GET /stores/1/edit
  def edit
  end

  # POST /stores
  # POST /stores.json
  def create
    #binding.pry
    @store = Store.new(store_params)
    #store_handler = StoreHandler.new(@store, params[:admin_login], params[:admin_password])
    respond_to do |format|
      if @store.save #deixar tenant opcional
      #if store_handler.create
        SpreeStoreCreationJob.perform_later(
          {
            store: @store,
            admin_login: params[:admin_login],
            admin_password: params[:admin_password]
          })
        format.html { redirect_to @store, notice: 'Store was successfully created.' }
        format.json { render :show, status: :created, location: @store }
      else
        format.html { render :new }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stores/1
  # PATCH/PUT /stores/1.json
  def update
    respond_to do |format|
      if @store.update(store_params)
        format.html { redirect_to @store, notice: 'Store was successfully updated.' }
        format.json { render :show, status: :ok, location: @store }
      else
        format.html { render :edit }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stores/1
  # DELETE /stores/1.json
  def destroy
    @store.destroy
    respond_to do |format|
      format.html { redirect_to stores_url, notice: 'Store was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /checksubdomain?subdomain=subdomain_name
  def check_subdomain
    #binding.pry
    response = Store.exists?(subdomain: params[:store][:subdomain])
    respond_to do |format|
      format.json { render json: !response, status: :ok }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_store
      @store = Store.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def store_params
      params.require(:store).permit(:subdomain).merge(seller: current_seller)
    end
end
