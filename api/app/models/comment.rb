class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  # ---------------------------------------------------------------------------
  #
  # Relations
  # ---------------------------------------------------------------------------
  #
  # -- Jots
  embedded_in :jots

  # ---------------------------------------------------------------------------
  #
  # FIELD
  # ---------------------------------------------------------------------------
  #
  # -- Comment
  field :user_id, :type => String
  field :author, :type => String
  field :content, :type => String

  def self.set(user_id, jot_id, content)
    current_comment = Jot.find(jot_id).comments.create :user_id => user_id, :author => User.find(user_id).username, :content => content

    if current_comment.errors.any?
      return JsonizeHelper.format :failed => true, :error => "Comment was not made", :errors => current_comment.errors.to_a
    else
      return JsonizeHelper.format :notice => "Comment Successfully Made"
    end

  rescue
    return JsonizeHelper.format :failed => true, :error => "Jot or User doesn't exist"
  end

  def self.unset(jot_id, comment_id)
      current_jot_comment_destroy = Jot.find(jot_id).comments.find(comment_id).destroy

      if current_jot_comment_destroy
        return JsonizeHelper.format :notice => "Comment was destroyed"
      else
        return JsonizeHelper.format :failed => true, :error => "Comment was not destroyed"
      end
    rescue
      return JsonizeHelper.format :failed => true, :error => "Comment doesn't exist"
  end
end
