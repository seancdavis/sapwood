class SapwoodInstaller

  def initialize(step, data)
    @step = step
    @data = data
  end

  def run
    send("run_step_#{@step}")
    complete_step
  end

  def self.run(step, data = {})
    SapwoodInstaller.new(step, data).run
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

    def run_step_2
      Sapwood.set('url', @data[:url])
    end

end
