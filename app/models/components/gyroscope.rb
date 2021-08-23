module Components
  # This component is a placeholder that will be stubbed in the tests.
  # The #status method would return actual values from a real life instrument.
  class Gyroscope
    def initialize(*)
      @x = 0
      @y = 0
      @z = 0
    end

    # values would represent velocities in each axis
    def status
      {
        x: x,
        y: y,
        z: z
      }
    end

    private

    attr_reader :x, :y, :z
  end
end
