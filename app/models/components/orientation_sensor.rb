module Components
  # This component is a placeholder that will be stubbed in the tests.
  # The #status method would return actual values from a real life instrument.
  class OrientationSensor
    def initialize(*)
      @pitch = 0
      @roll = 0
    end

    def status
      {
        pitch: pitch,
        roll: roll
      }
    end

    private

    attr_reader :pitch, :roll
  end
end
