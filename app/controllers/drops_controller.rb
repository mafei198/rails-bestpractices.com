class DropsController < InheritedResources::Base
  before_filter :authenticate_user!, :only => [:new, :edit, :create, :update, :destroy]

  protected
    def begin_of_association_chain
      current_user
    end
end
