class CustomStatementsController < ApplicationController
  def create
     @user = User.find(params[:user_id])

     if @user.custom_statements.create(custom_statement_params)
       redirect_to @user,
           notice: 'Custom Statement was successfully created.'
     else
        redirect_to @user,
           alert: 'Error creating Custom Statement.'
     end
  end # create method end.

# ADDED:

  # GET /posts/:post_id/comments
  # GET /posts/:post_id/comments.xml
  def index
    #1st you retrieve the post thanks to params[:post_id]
    user = User.find(params[:user_id])
    #2nd you get all the comments of this post
    @custom_statements = user.custom_statements

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @custom_statements }
    end
  end

  # GET /posts/:post_id/comments/:id
  # GET /comments/:id.xml
  def show
    #1st you retrieve the post thanks to params[:post_id]
    user = User.find(params[:user_id])
    #2nd you retrieve the comment thanks to params[:id]
    @custom_statement = user.custom_statements.find(params[:id])

    #puts "in custom statement show method."

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @custom_statement }
    end
  end

  # GET /posts/:post_id/comments/new
  # GET /posts/:post_id/comments/new.xml
  def new
    #1st you retrieve the post thanks to params[:post_id]
    user = User.find(params[:user_id])
    #2nd you build a new one
    @custom_statement = user.custom_statements.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @custom_statement }
    end
  end

  # GET /posts/:post_id/comments/:id/edit
  def edit
    #1st you retrieve the post thanks to params[:post_id]
    user = User.find(params[:user_id])
    #2nd you retrieve the comment thanks to params[:id]
    @custom_statement = user.custom_statements.find(params[:id])
  end

  # POST /posts/:post_id/comments
  # POST /posts/:post_id/comments.xml
#   def create
#     #1st you retrieve the post thanks to params[:post_id]
#     user = User.find(params[:user_id])
#     #2nd you create the comment with arguments in params[:comment]
#     @custom_statement = user.custom_statements.create(params[:custom_statement])

#     respond_to do |format|
#       if @custom_statement.save
#         #1st argument of redirect_to is an array, in order to build the correct route to the nested resource comment
#         format.html { redirect_to([@custom_statement.user, @custom_statement], :notice => 'Custom Statement was successfully created.') }
#         #the key :location is associated to an array in order to build the correct route to the nested resource comment
#         format.xml  { render :xml => @custom_statement, :status => :created, :location => [@custom_statement.user, @custom_statement] }
#       else
#         format.html { render :action => "new" }
#         format.xml  { render :xml => @custom_statement.errors, :status => :unprocessable_entity }
#       end
#     end
#   end

  # PUT /posts/:post_id/comments/:id
  # PUT /posts/:post_id/comments/:id.xml
  def update
    #1st you retrieve the post thanks to params[:post_id]
    user = User.find(params[:user_id])
    #2nd you retrieve the comment thanks to params[:id]
    @custom_statement = user.custom_statements.find(params[:id])

    respond_to do |format|
      if @custom_statement.update(custom_statement_params)
        format.html { redirect_to [@custom_statement.user, @custom_statement], notice: 'Custom Statement was successfully updated.' }
        format.json { render :show, status: :ok, location: @custom_statement }
      else
        format.html { render :edit }
        format.json { render json: @custom_statement.errors, status: :unprocessable_entity }
      end
#       if @custom_statement.update_attributes(params[:custom_statement])
#         #1st argument of redirect_to is an array, in order to build the correct route to the nested resource comment
#         format.html { redirect_to([@custom_statement.user, @custom_statement], :notice => 'Custom Statment was successfully updated.') }
#         format.xml  { head :ok }
#       else
#         format.html { render :action => "edit" }
#         format.xml  { render :xml => @custom_statement.errors, :status => :unprocessable_entity }
#       end
    end
  end

  # DELETE /posts/:post_id/comments/1
  # DELETE /posts/:post_id/comments/1.xml
  def destroy
    #1st you retrieve the post thanks to params[:post_id]
    user = User.find(params[:user_id])
    #2nd you retrieve the comment thanks to params[:id]
    @custom_statement = user.custom_statements.find(params[:id])
    @custom_statement.destroy

    respond_to do |format|
      #1st argument reference the path /s/:user_id/custom_statements/
      format.html { redirect_to(user_custom_statements_url) }
      format.xml  { head :ok }
    end
  end
#end

# == added end.

private

  def custom_statement_params
    params.require(:custom_statement).permit(:statement, :importance, :degree_of_truth)
  end # comment_params end.

end
