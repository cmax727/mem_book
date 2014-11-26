module VerifyNotLoggedIn
  def self.included(base)
    base.send(:extend, ClassMethods)
    base.send(:include, InstanceMethods)

    base.before_filter(:verify_not_logged_in)
  end

  module ClassMethods

  end

  module InstanceMethods

  private

    def verify_not_logged_in
      redirect_to(dashboard_url) if current_user
    end

  end
end