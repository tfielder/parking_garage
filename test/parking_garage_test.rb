gem 'minitest', '~> 5.2'
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/parking_garage'

class ParkingGarageTest < Minitest::Test
  def setup
    @parking_garage = ParkingGarage.new
    @parking_garage.levels = 5
    @parking_garage.rows = 5
    @parking_garage.spaces = 5
    @parking_garage.letter = "e"
    @parking_garage.initialize_garage
  end

  def test_creates_new_class
    assert @parking_garage
  end

  def test_it_has_attributes
    assert_equal 5, @parking_garage.levels
    assert_equal 5, @parking_garage.spaces
    assert_equal 5, @parking_garage.rows
    assert_equal "e", @parking_garage.letter
  end

  def test_it_creates_a_garage
    args = {}
    assert_equal @parking_garage.garage[0][0][0][:occupied], false
    assert_equal @parking_garage.garage[0][0][1][:occupied], false
    assert_equal @parking_garage.garage[0][0][2][:occupied], false
    assert_equal @parking_garage.garage[0][1][0][:occupied], false
    assert_equal @parking_garage.garage[0][1][1][:occupied], false
    assert_equal @parking_garage.garage[0][1][2][:occupied], false
    assert_equal @parking_garage.garage[0][2][0][:occupied], false
    assert_equal @parking_garage.garage[0][2][1][:occupied], false
    assert_equal @parking_garage.garage[0][2][2][:occupied], false
  end

  def test_it_adds_a_car
    args = {}
    args[:level] = 0
    args[:row] = 4
    args[:space] = 0
    @parking_garage.add_car(args)
    assert_equal @parking_garage.garage[0][4][0][:vehicle_type], "car"
  end

  def test_it_adds_a_motorcycle
    args = {}
    args[:level] = 0
    args[:row] = 4
    args[:space] = 0
    @parking_garage.add_motorcycle(args)
    assert_equal @parking_garage.garage[0][4][0][:vehicle_type], "motorcycle"
  end

  def test_it_adds_a_bus
    args = {}
    args[:level] = 0
    args[:row] = 4
    args[:space] = 0
    @parking_garage.add_bus(args)
    assert_equal @parking_garage.garage[0][4][0][:vehicle_type], "bus"
    assert_equal @parking_garage.garage[0][4][1][:vehicle_type], "bus"
    assert_equal @parking_garage.garage[0][4][2][:vehicle_type], "bus"
    assert_equal @parking_garage.garage[0][4][3][:vehicle_type], "bus"
    assert_equal @parking_garage.garage[0][4][4][:vehicle_type], "bus"
  end

  def test_it_does_not_add_a_bus
    args = {}
    args[:level] = 1
    args[:row] = 5
    args[:space] = 2
    args = @parking_garage.convert_spot(args)
    @parking_garage.add_bus(args)
    assert_equal @parking_garage.garage[0][4][0][:vehicle_type], "none"
    assert_equal @parking_garage.garage[0][4][1][:vehicle_type], "none"
    assert_equal @parking_garage.garage[0][4][2][:vehicle_type], "none"
    assert_equal @parking_garage.garage[0][4][3][:vehicle_type], "none"
    assert_equal @parking_garage.garage[0][4][4][:vehicle_type], "none"
  end

  def test_it_removes_a_bus
    args = {}
    args[:level] = 1
    args[:row] = 5
    args[:space] = 1
    @parking_garage.add_bus(args)
    @parking_garage.remove_bus(args)
  end

  def test_it_does_not_remove_bus
    args = {}
    args[:level] = 1
    args[:row] = 5
    args[:space] = 1
    args = @parking_garage.convert_spot(args)
    args[:vehicle_id] = "12345"
    @parking_garage.add_bus(args)
    args[:space] = 1
    assert_equal @parking_garage.garage[0][4][1][:vehicle_id], "12345"
    @parking_garage.remove_bus(args)
    assert_equal @parking_garage.garage[0][4][0][:vehicle_type], "bus"
    assert_equal @parking_garage.garage[0][4][1][:vehicle_type], "bus"
    assert_equal @parking_garage.garage[0][4][2][:vehicle_type], "bus"
    assert_equal @parking_garage.garage[0][4][3][:vehicle_type], "bus"
    assert_equal @parking_garage.garage[0][4][4][:vehicle_type], "bus"
  end

  def test_bus_in_range?
    args = {}
    args[:level] = 1
    args[:row] = 5
    args[:space] = 1
    args = @parking_garage.convert_spot(args)
    assert_equal @parking_garage.bus_coordinates_in_range?(args), true
    args[:space] = 5
    assert_equal @parking_garage.bus_coordinates_in_range?(args), false
    args[:space] = 1
    assert_equal @parking_garage.bus_coordinates_in_range?(args), false
  end
end