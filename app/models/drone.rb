class Drone
  STATES = %i[off hovering moving].freeze
  COMMANDS = %i[take_off land move_forward].freeze

  TAKE_OFF_HEIGHT = 1

  def initialize(
    orientation_sensor: Components::OrientationSensor.new,
    gyroscope: Components::Gyroscope.new,
    engines: 4
  )

    @state = :off
    @engines = Array.new(engines) do |i|
      Components::Engine.new(id: i + 1, orientation_sensor: orientation_sensor)
    end
    @orientation = orientation_sensor
    @gyroscope = gyroscope
  end

  def take_off
    process_command(:take_off)
  end

  def land
    process_command(:land)
  end

  def move_forward(power)
    process_command(:move_forward, power: power)
  end

  # TODO: implement other move commands

  def status
    {
      state: state,
      roll: orientation.status[:roll],
      pitch: orientation.status[:pitch],
      gyroscope: gyroscope.status,
      engines: engines.map(&:status)
    }
  end

  private

  attr_accessor :state
  attr_reader :engines, :orientation, :gyroscope

  def process_command(command, options = {})
    raise 'invalid command' unless COMMANDS.include?(command)

    case command
    when :take_off
      raise 'invalid state tranisition' if state != :off

      engines.each(&:init)
      @state = :hovering
    when :land
      raise 'invalid state tranisition' if state == :off

      engines.each(&:land)
      @state = :off
    when :move_forward
      raise 'invalid power arg' unless (1..100).include?(options[:power])

      engines.each { |engine| engine.update_power(options[:power]) }
      @state = :moving
    end
  end
end
