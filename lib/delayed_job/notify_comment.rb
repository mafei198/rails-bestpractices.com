class DelayedJob::NotifyComment < Struct.new(:comment_id)
  def perform
    comment = Comment.find(comment_id)
    commentable = comment.commentable
    emails = []

    email = commentable.user.email
    if comment.commentable_type == "BlogPost"
      NotificationMailer.notify_comment(email, comment).deliver
    elsif email.present? and commentable.user != comment.user
      emails << email
      NotificationMailer.notify_comment(email, comment).deliver if commentable.user.send("comment_#{comment.commentable_type.underscore}?")
    end

    comments = commentable.comments
    comments.each do |c|
      email = c.user_email
      if email.present? and email != comment.user_email and !emails.include? email
        emails << email
        NotificationMailer.notify_comment(email, comment).deliver if commentable.user.send("after_#{comment.commentable_type.underscore}_comment?")
      end
    end
  end
end
