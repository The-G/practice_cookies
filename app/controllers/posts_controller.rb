class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
    @email = cookies[:email]
    @_cookies = cookies
    @permission_cookies = @_cookies[:permission]


  end

  def cookie_rec
    # 쿠키 :email을 설정 (유효기간은 3개월)
    cookies[:email] = {value: params[:email],
                       expires: 1.minute.from_now,
                       http_only: true}

    respond_to do |format|
      format.html { redirect_to :back }
    end
  end

  def cookie_btn

    @_cookies = cookies
    post = Post.find(params[:id])
    permission_ids = @_cookies[:permission]
    permission_ids = [] if permission_ids.nil?

    if permission_ids.split(',').include? post.id.to_s
      respond_to do |format|
        format.html { redirect_to :back }
        format.json { render :json => {:want_delete_count => post.delete_count,
                                       :cookies_status => '이미 클릭했습니다.'} }
      end
    else
      post.delete_count = post.delete_count + 1
      post.save

      if permission_ids == []
        permission_ids.push(post.id)
      else
        permission_ids.concat(',').concat(post.id.to_s)
      end

      @_cookies[:permission] = {value: permission_ids,
                                expires: 60.second.from_now,
                                # Time.zone.now.end_of_day
                                http_only: true}

      respond_to do |format|
        format.html { redirect_to :back }
        format.json { render :json => {:want_delete_count => post.delete_count,
                                       :cookies_status => '삭제 요청 되었습니다.'} }
      end
    end


    # cookies.signed[:comment_data] = { value: {comment_id: 1, comment_user:2}.to_yaml, expires: 2.hour.from_now }

    # if cookies[:permission_count] == 'clicked'
    #   respond_to do |format|
    #     format.html { redirect_to :back }
    #     format.json { render :json => {:want_delete_count => '이미 클릭 했습니다.'} }
    #   end
    # else
    #   cookies[:permission_count] = {value: 'clicked',
    #                                 expires: 1.minute.from_now,
    #                                 http_only: true}
    #   respond_to do |format|
    #     format.html { redirect_to :back }
    #     format.json { render :json => {:want_delete_count => '삭제 요청 되었습니다.'} }
    #   end
    # end

  end


  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
    @_cookies = cookies
    @permission_cookies = @_cookies[:permission]
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def post_params
    params.require(:post).permit(:email)
  end
end
