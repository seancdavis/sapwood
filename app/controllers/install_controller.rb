class InstallController < ApplicationController

  helper_method :current_step

  def show
    Sapwood.reload!
    if params[:step].to_i == current_step
      @total_steps = 8
      render current_step.to_s
    else
      redirect_to install_path(current_step)
    end
  end

  def update
    @current_step = SapwoodInstaller.run(current_step)
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

end
