class Notification < ActiveRecord::Base
  attr_accessible :user_id, :message, :viewed, :link, :initiator, :object_type, :object_id

  belongs_to :user

  validates_presence_of :user_id, :message

  default_scope { order('created_at DESC') }
  scope :unread, -> { where(viewed: false) }

  self.per_page = 10

  # user_id = ID of the RECIPIENT
  def self.send_new_comment_notification(user_id, comment, mine)

    username = comment.user.display_name
    sit_owner = comment.sit.user.display_name
    if mine
      message = "#{username} commented on your sit."
    else
      if sit_owner == username
        message = "#{username} also commented on their own sit."
      else
        message = "#{username} also commented on #{sit_owner}'s sit."
      end
    end

    # No need to notify the user if they've just commented on their own sit
    if comment.user.id != user_id
      Notification.create(
        message: message,
        user_id: user_id,
        link: "/sits/#{comment.sit.id}\#comment-#{comment.id}",
        initiator: comment.user.id,
        object_type: 'comment',
        object_id: comment.id
      )
    end

  end

  # user_id = ID of the RECIPIENT
  def self.send_new_follower_notification(user_id, follow)

    Notification.create(
      message: "#{follow.follower.display_name} is now following you!",
      user_id: user_id,
      link: Rails.application.routes.url_helpers.user_path(follow.follower),
      initiator: follow.follower.id,
      object_type: 'follow',
      object_id: follow.id
    )

  end

  def self.send_new_sit_like_notification(user_id, like)

    Notification.create(
      message: "#{like.user.display_name} likes your entry.",
      user_id: user_id,
      link: Rails.application.routes.url_helpers.sit_path(like.likeable_id),
      initiator: like.user.id,
      object_type: 'like',
      object_id: like.id
    )

  end

  def self.mark_all_as_read(current_user)
    @user = current_user
    @notifications = @user.notifications.unread
    @notifications.each do |n|
      n.viewed = true
      n.save
    end
  end

  private

    def self.can_combine_likes?(last_notification, sit_link)
      last_notification.present? and last_notification.link == sit_link and last_notification.message.include?('like')
    end
end

# == Schema Information
#
# Table name: notifications
#
#  created_at :datetime
#  id         :integer          not null, primary key
#  initiator  :integer
#  link       :string(255)
#  message    :string(255)
#  updated_at :datetime
#  user_id    :integer
#  viewed     :boolean          default(FALSE)
#  object_type :string(255)
#  object_id  :integer
#
