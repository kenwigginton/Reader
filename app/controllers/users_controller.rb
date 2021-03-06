class UsersController < ApplicationController
  skip_before_filter :authorize_reader, :authorize_admin, only: [:new, :create]
  skip_before_filter :authorize_admin, only: [:show, :edit, :destroy, :update]
  # GET /users
  # GET /users.json
  def index
    @users = User.order(:email)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    unless admin? # if not admin, restrict access
      @user = current_user
    else
      @user = User.find(params[:id])
    end
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    unless admin? # if admin, give all access
      @user = current_user
    else
      @user = User.find(params[:id])
    end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        
        format.html { post_signup(@user.email, @user.password) }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to users_url, notice: 'User #{@user.email} was successfully updated with role: #{@user.role}' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end
  
  private
  
  def post_signup(email, password)
    user = User.find_by_email(email)
    if user and user.authenticate(password)
      session[:user_id] = user.id
      
      if session[:return_to]
        redirect_to session[:return_to]
        session[:return_to] = nil
        return
      end
      redirect_to reader_path #eval("#{user.role}_url")
      
    else
      redirect_to login_url, alert: "Invalid Email or Password"
    end
  end
end
