class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    
    alias_action :create, :read, :update, :destroy, :to => :crud

    if user.admin?
      can :crud, :all
    elsif user.manager?
      can :manage, User
    elsif user.regular?
      can :crud, User, :id => user.id
      can :crud, Timezone, :user_id => user.id
    end
  end
end
