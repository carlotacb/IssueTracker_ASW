class CommentsController < ApplicationController
  protect_from_forgery with: :null_session
  acts_as_token_authentication_handler_for User, fallback: :devise
  before_action :authenticate_user!

  def index
    @issue = Issue.find(params[:issue_id])
    comments = @issue.comments
    respond_to do |format|
      format.json {render json: comments, status: :ok, each_serializer: CommentSerializer}
    end
  end

  def show
    @issue = Issue.find(params[:issue_id])
    @comment = @issue.comments.find(params[:id])
    respond_to do |format|
      format.json {render json: @comment, status: :ok, each_serializer: CommentSerializer}
    end
  end

	def create
    @comment = Comment.new(comment_params)
    @issue = Issue.find(params[:issue_id])
    @comment.issue_id = @issue.id
    @comment.user_id = current_user.id
    @comment.save
    respond_to do |format|
      format.json {render json: @comment, status: :created, each_serializer: CommentSerializer}
      format.html {redirect_to issue_path(@issue)}
    end
  end
  
  def destroy
    @issue = Issue.find(params[:issue_id])
    @comment = @issue.comments.find(params[:id])
    if @comment.user_id == current_user.id
      @comment.destroy
    end
    respond_to do |format|
      if @comment.user_id == current_user.id
        format.json {render json: {}, status: :ok}
        format.html {redirect_to issue_path(@issue)}
      else
        format.json {render json: {error: "Forbidden, you are not the creator of this comment"}, status: :forbidden}
      end
    end
  end

  def update
    @issue = Issue.find(params[:issue_id])
    @comment = @issue.comments.find(params[:id])
    if @comment.user_id == current_user.id
      @comment.update(comment_params)
    end
    respond_to do |format|
      if @comment.user_id == current_user.id
        format.json {render json: @comment, status: :ok, each_serializer: CommentSerializer}
        format.html {redirect_to issue_path(@issue)}
      else
        format.json {render json: {error: "Forbidden, you are not the creator of this comment"}, status: :forbidden}
      end
    end
  end

  def show_attachment
    @issue = Issue.find(params[:issue_id])
    @comment = @issue.comments.find(params[:id])
    respond_to do |format|
      if @comment.attachment.file?
        format.json {render json: @comment, status: :ok, serializer: AttachmentSerializer}
      else
        format.json {render json: {}, status: :ok}
      end
    end
  end

  def create_attachment
    @issue = Issue.find(params[:issue_id])
    @comment = @issue.comments.find(params[:id])
    if @comment.user_id == current_user.id
      @comment.attachment = Paperclip.io_adapters.for(params[:file])
      @comment.save
    end
    respond_to do |format|
      if @comment.user_id == current_user.id
        format.json {render json: @comment, status: :created, serializer: AttachmentSerializer}
      else
        format.json {render json: {error: "Forbidden, you are not the creator of this comment"}, status: :forbidden}
      end        
    end
  end
 
  private
    def comment_params
      params.permit(:body, :attachment, :issue_id, :user_id, :comment)
    end
end
