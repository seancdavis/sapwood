class InstallController < ApplicationController

  skip_before_filter :authenticate_user!
  skip_before_filter :verify_profile_completion

  before_filter :set_total_steps

  helper_method :current_step

  def show
    if params[:step].to_i <= current_step
      render current_step.to_s
    else
      redirect_to install_path(current_step)
    end
  end

  def update
    if current_step == @total_steps
      InstallSapwood.complete!
      redirect_to new_user_session_path
    else
      @current_step = InstallSapwood.run(current_step, params[:install])
      redirect_to install_path(current_step)
    end
  end

  private

    def verify_installation
      redirect_to root_path if Sapwood.installed?
    end

    def current_step
      @current_step ||= begin
        step = Sapwood.config.current_step
        step = 1 if step.blank?
        Sapwood.set('current_step', step)
        Sapwood.write!
        step
      end
    end

    def set_total_steps
      @total_steps = 7
    end

end
