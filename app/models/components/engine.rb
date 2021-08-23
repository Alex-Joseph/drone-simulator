module Components
  class Engine
    COMMANDS = %i[init land set_power].freeze
    INITIAL_POWER = 0
    DECENDING_POWER = 5
    TAKE_OFF_POWER = 10

    def initialize(id:, orientation_sensor:)
      @id = id
      @state = :off
      @power = INITIAL_POWER
      @orientation_sensor = orientation_sensor
    end

    def init
      process_command(:init)
    end

    def land
      process_command(:land)
    end

    def update_power(power)
      process_command(:set_power, power: power)
    end

    def status
      {
        id: id,
        status: state,
        power: power
      }
    end

    private

    attr_accessor :state, :power, :id, :orientation_sensor

    def process_command(command, options = {})
      raise 'invalid command' unless COMMANDS.include?(command)

      case command
      when :init
        raise 'invalid state tranisition' if state != :off

        @power = TAKE_OFF_POWER
        @state = :on
      when :land
        raise 'invalid state tranisition' if state == :off

        @power = DECENDING_POWER

        # check the sensor on interval that the drone is still in the air
        sleep(1.second) while orientation_sensor.status[:roll] > 0

        # once the drone has landed, turn the engine off
        @power = INITIAL_POWER
        @state = :off
      when :set_power
        raise 'invalid state tranisition' if state == :off

        @power = options[:power]
      end
    end
  end
end
