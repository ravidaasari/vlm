class InfobloxesController < ApplicationController
  before_action :set_infoblox, only: [:show, :edit, :update, :destroy]

  # GET /infobloxes
  # GET /infobloxes.json
  def index
    @infobloxes = Infoblox.all
  end

  # GET /infobloxes/1
  # GET /infobloxes/1.json
  def show
  end

  # GET /infobloxes/new
  def new
    @infoblox = Infoblox.new
  end

  # GET /infobloxes/1/edit
  def edit
  end

  # POST /infobloxes
  # POST /infobloxes.json
  def create
    @infoblox = Infoblox.new(infoblox_params)

    respond_to do |format|
      if @infoblox.save
        format.html { redirect_to @infoblox, notice: 'Infoblox was successfully created.' }
        format.json { render :show, status: :created, location: @infoblox }
      else
        format.html { render :new }
        format.json { render json: @infoblox.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /infobloxes/1
  # PATCH/PUT /infobloxes/1.json
  def update
    respond_to do |format|
      if @infoblox.update(infoblox_params)
        format.html { redirect_to @infoblox, notice: 'Infoblox was successfully updated.' }
        format.json { render :show, status: :ok, location: @infoblox }
      else
        format.html { render :edit }
        format.json { render json: @infoblox.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /infobloxes/1
  # DELETE /infobloxes/1.json
  def destroy
    @infoblox.destroy
    respond_to do |format|
      format.html { redirect_to infobloxes_url, notice: 'Infoblox was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_infoblox
      @infoblox = Infoblox.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def infoblox_params
      params.require(:infoblox).permit(:infoblox_url, :infoblox_username, :infoblox_password, :encrypted_infoblox_password, :encrypted_infoblox_password_iv)
    end
end
