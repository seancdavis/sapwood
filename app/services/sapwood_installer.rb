class SapwoodInstaller

  def initialize(step)
    @step = step
  end

  def run
    send("run_step_#{@step}")
    complete_step
  end

  def self.run(step)
    SapwoodInstaller.new(step).run
  end

  private

    def complete_step
      @step += 1
      Sapwood.set('current_step', @step)
      Sapwood.write!
      @step
    end

    def run_step_1
      true
    end

end
