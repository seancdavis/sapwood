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

    def run_step_3
      Sapwood.set('default_from', "#{@data[:name]} <#{@data[:email]}>")
    end

    def run_step_4
      Sapwood.set('send_grid', @data.to_hash)
    end

    def run_step_5
      Sapwood.set('amazon_aws', @data.to_hash)
    end

    def run_step_6
      User.create!(
        :name => @data[:name],
        :email => @data[:email],
        :password => @data[:password],
        :password_confirmation => @data[:password],
        :is_admin => true
      )
    end

end
