class MessagingsController < ApplicationController
  before_action :set_messaging, only: [:show, :edit, :update, :destroy]

  # GET /messagings
  # GET /messagings.json
  def index
    @search = MessagingSearch.new(params[:search])
    @messagings = @search.scope
  end

  # GET /messagings/1
  # GET /messagings/1.json
  def show
  end

  # GET /messagings/new
  def new
    @messaging = Messaging.new
  end

  # GET /messagings/1/edit
  def edit
  end

  # POST /messagings
  # POST /messagings.json
  def create
    @messaging = Messaging.new(messaging_params)

    respond_to do |format|
      if @messaging.save
        format.html { redirect_to @messaging, notice: 'Messaging was successfully created.' }
        format.json { render :show, status: :created, location: @messaging }
      else
        format.html { render :new }
        format.json { render json: @messaging.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /messagings/1
  # PATCH/PUT /messagings/1.json
  def update
    respond_to do |format|
      if @messaging.update(messaging_params)
        format.html { redirect_to @messaging, notice: 'Messaging was successfully updated.' }
        format.json { render :show, status: :ok, location: @messaging }
      else
        format.html { render :edit }
        format.json { render json: @messaging.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messagings/1
  # DELETE /messagings/1.json
  def destroy
    @messaging.destroy
    respond_to do |format|
      format.html { redirect_to messagings_url, notice: 'Messaging was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_messaging
      @messaging = Messaging.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def messaging_params
      params.require(:messaging).permit(:date, :receiver, :sender, :message, :image)
    end
end
