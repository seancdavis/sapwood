class InstallController < ApplicationController

  before_filter :set_total_steps

  helper_method :current_step

  def show
    # Sapwood.reload!
    if params[:step].to_i == current_step
      render current_step.to_s
    else
      redirect_to install_path(current_step)
    end
  end

  def update
    @current_step = SapwoodInstaller.run(current_step, params[:install])
    redirect_to install_path(current_step)
  end

  private

    def verify_installation
    end

    def current_step
      @current_step ||= begin
        step = Sapwood.config.current_step
        step = 1 if step.nil?
        Sapwood.set('current_step', step)
        Sapwood.write!
        step
      end
    end

    def set_total_steps
      @total_steps = 8
    end

end
