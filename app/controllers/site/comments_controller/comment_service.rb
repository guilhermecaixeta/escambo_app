# typed: true

class Site::CommentsController::CommentService
  extend T::Sig

  def initialize(user)
    @user = user
  end

  sig { params(params: T.untyped).returns(Comment) }

  def create(params)
    @rate = params[:member][:rating]
    params.delete(:member)

    @comment = Comment.new(params)
    @comment.user_id = @user.id
    if @comment.valid?

      @comment.save!
      advertisement = Advertisement.find @comment.advertisement_id
      @user.rate advertisement, @rate
    end

    @comment
  end

  sig { params(params: T.untyped, comment: Comment).returns(Comment) }

  def update(params, comment)
    @comment = comment
    @comment.assign_attributes(params)

    if @comment.valid?
      @comment.save!
    end

    @comment
  end

  def self.destroy(comment)
    @comment = comment
    @comment.destroy
  end
end
