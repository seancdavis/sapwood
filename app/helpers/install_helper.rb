# frozen_string_literal: true

module InstallHelper
  def install_progress
    current_step.to_f / @total_steps.to_f
  end
end
