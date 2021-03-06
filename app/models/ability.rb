class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      can [:read, :like], Post
      can :create, Post do |post|
        post.owner.is_friend_with_user_id?(user)
      end
      can [:create, :destroy], Post, :owner_id => user.id
      can :destroy, Post, :author_id => user.id
      can :all, Post
      can [:read, :like], Comment
      can [:read, :create], Like
      can :destroy, Like, :user_id => user.id
      can [:create, :destroy, :destroy_comment], Comment, :post => { :owner_id => user.id }
      can :create, Comment do |comment|
        comment.post.owner.is_friend_with_user_id?(user)
      end
      can [:destroy, :destroy_comment], Comment, :user_id => user.id
      can [:create, :update, :destroy], PersonalInfo, :user_id => user.id
      can :read, PersonalInfo
      can :read, User
      can :create, Friendship
      can :read, Friendship, :approved => true
      can [:read, :destroy], Friendship, :user1_id => user.id
      can [:read, :destroy], Friendship, :user2_id => user.id
      can :update, Friendship, :user2_id => user.id, :approved => false
      can :create, Message
      can [:read, :update], Message, :receiver_id => user.id
      can :read, Message, :sender_id => user.id
    else
      can :create, User
      can :read, PersonalInfo, :id => 0
    end
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
