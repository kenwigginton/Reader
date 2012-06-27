class SubscriptionsController < ApplicationController
  skip_before_filter :authorize_admin
  # GET /subscriptions
  # GET /subscriptions.json
  def index
    @subscriptions = Subscription.find_all_by_user_id(session[:user_id])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @subscriptions }
    end
  end

  # GET /subscriptions/1
  # GET /subscriptions/1.json
  def show
    @subscription = Subscription.all

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @subscription }
    end
  end

  # GET /subscriptions/new
  # GET /subscriptions/new.json
  def new
     @subscription = Subscription.new

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @subscription }
      end
  end

  # GET /subscriptions/1/edit
  def edit
    @subscription = Subscription.find(params[:id])
  end

  # POST /subscriptions
  # POST /subscriptions.json
  def create
    @subscription = Subscription.new
    @subscription.user = current_user
    @subscription.feed = Feed.find(params[:feed_id])
    
    respond_to do |format|
      if @subscription.save
        
        #since user was on the feed they wanted to subscribe to, they have already read it
        if session[:read_subscriptions]
          session[:read_subscriptions] << @subscription.id
        end
        
        format.html { redirect_to request.referer }
        format.js
        format.json { render json: @subscription, status: :created, location: @subscription}
      else
        # TODO
        # This should definitely be redone to properly handle errors
        notice = @subscription.errors.full_messages.first.to_s
        redirect_to request.referer, notice: notice
      end
    end
  end

  # PUT /subscriptions/1
  # PUT /subscriptions/1.json
  def update
    @subscription = Subscription.find(params[:id])

    respond_to do |format|
      if @subscription.update_attributes(params[:subscription])
        format.html { redirect_to @subscription, notice: 'Subscription was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @subscription.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subscriptions/1
  # DELETE /subscriptions/1.json
  def destroy
   # if params[:feed_id]
  #    @subscription = Subscription.find_by_user_id_and_feed_id(session[:user_id], params[:feed_id])
  #  else
      @subscription = Subscription.find(params[:id])
  #  end
    
    #Remove unwanted feed from session tracking
    if session[:read_subscriptions]
      session[:read_subscriptions].delete @subscription.id
    end
      
      
    @subscription.destroy
    

    
    respond_to do |format|
      format.html { redirect_to request.referer }
      format.js
      format.json { head :no_content }
    end
  end
end
