require 'test_helper'

class DroneTest < ActiveSupport::TestCase
  # take_off method
  def test_drone_can_take_off
    @mock_sensor = Components::OrientationSensor.new
    @drone = Drone.new(orientation_sensor: @mock_sensor)

    @drone.take_off

    @mock_sensor.stub(:status, { roll: 1, pitch: 0 }) do
      expected_status = {
        state: :hovering,
        roll: Drone::TAKE_OFF_HEIGHT,
        pitch: 0,
        gyroscope: { x: 0, y: 0, z: 0 },
        engines: [
          { id: 1, status: :on, power: Components::Engine::TAKE_OFF_POWER },
          { id: 2, status: :on, power: Components::Engine::TAKE_OFF_POWER },
          { id: 3, status: :on, power: Components::Engine::TAKE_OFF_POWER },
          { id: 4, status: :on, power: Components::Engine::TAKE_OFF_POWER }
        ]
      }

      assert_equal expected_status, @drone.status
    end
  end

  # land method
  def test_drone_can_land
    @mock_sensor = Components::OrientationSensor.new
    @drone = Drone.new(orientation_sensor: @mock_sensor)
    @drone.take_off

    @drone.land

    @mock_sensor.stub(:status, { roll: 0, pitch: 0 }) do
      expected_status = {
        state: :off,
        roll: 0,
        pitch: 0,
        gyroscope: { x: 0, y: 0, z: 0 },
        engines: [
          { id: 1, status: :off, power: Components::Engine::INITIAL_POWER },
          { id: 2, status: :off, power: Components::Engine::INITIAL_POWER },
          { id: 3, status: :off, power: Components::Engine::INITIAL_POWER },
          { id: 4, status: :off, power: Components::Engine::INITIAL_POWER }
        ]
      }

      assert_equal expected_status, @drone.status
    end
  end

  # move_forward method
  def test_drone_can_move_forward
    power = rand(1..100)
    @mock_sensor = Components::OrientationSensor.new
    @mock_gyroscope = Components::Gyroscope.new
    @drone = Drone.new(orientation_sensor: @mock_sensor, gyroscope: @mock_gyroscope)
    @drone.take_off

    @drone.move_forward(power)

    # random value simulating gyroscope output
    forward_velocity = power / Math::PI

    @mock_gyroscope.stub(:status, { x: 0, y: 0, z: forward_velocity }) do
      @mock_sensor.stub(:status, { pitch: 10, roll: 1 }) do
        expected_status = {
          state: :moving,
          roll: Drone::TAKE_OFF_HEIGHT,
          pitch: 10,
          gyroscope: { x: 0, y: 0, z: forward_velocity },
          engines: [
            { id: 1, status: :on, power: power },
            { id: 2, status: :on, power: power },
            { id: 3, status: :on, power: power },
            { id: 4, status: :on, power: power }
          ]
        }

        assert_equal expected_status, @drone.status
      end
    end
  end
end
