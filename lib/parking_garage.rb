class ParkingGarage
  attr_accessor :levels, :rows, :spaces, :garage, :letter

  def initialize
    @levels, @rows, @spaces, @letter = 0
  end

  def welcome_message
    puts ''
    puts 'Welcome to Parking Garage'
  end

  def print_instructions
    puts "At anytime type 'q' to quit the program."
    puts "Type 'a' to add a vehicle to the parking garage."
    puts "Type 'r' to remove a vehicle from the parking garage."
    puts "Type 'print' to print the parking garage"
  end

  def run_program
    welcome_message
    get_garage_details
    initialize_garage
    get_response
    farewell_message
  end

  def get_response
    response = 0
    while response != 'q'
      puts " "
      print_instructions
      response = gets.chomp
      add_vehicle if response == 'a'
      remove_vehicle if response == 'r'
      print_garage if response == 'print'
    end
  end

  def get_garage_details
    @levels = get_details_for(:levels)
    @rows = get_details_for(:rows)
    @spaces = get_details_for(:spaces)
    @letter = convert_space_to_letter
  end

  def get_details_for(feature)
    puts "How many levels does this garage have?" if feature == :levels
    puts "How many rows does each level have?" if feature == :rows
    puts "How many parking spaces does each row have?" if feature == :spaces
    feature = gets.chomp.to_i
    while (feature < 1)
      puts "Choose a number greater than or equal to 1"
      feature = gets.chomp.to_i
    end
    feature
  end

  def convert_space_to_letter
    letter = "a"
    (@spaces - 1).times do
      letter = letter.succ
    end
    @letter = letter
  end

  def initialize_garage
    @garage = Array.new(@levels)
    (0..@levels - 1).each do |level|
      @garage[level] = Array.new(@rows) { Array.new(@spaces) {0} }
    end
    (0..@levels - 1).each do |level|
      (0..@rows - 1).each do |row|
        (0..@spaces - 1).each do |space|
          @garage[level][row][space] = {occupied: false, space_type: "compact", vehicle_type: "none", vehicle_id: "none"}
          @garage[level][row][space][:space_type] = "large" if row == @rows - 1
          @garage[level][row][space][:space_type] = "motorcycle" if row == 0
        end
      end
    end
  end

  def add_vehicle
    args = {}
    args[:vehicle_type] = get_vehicle_type
    puts "Type the spot you would like to park the vehicle."
    args = get_spot_id(args)
    args = convert_spot(args)
    validate_spot(args)
  end

  def get_spot_id(args)
    while !valid_vehicle_spot(args)
      args[:level] = validate_details_for(:level)
      args[:row] = validate_details_for(:row)
      args[:space] = validate_space
    end
    args
  end

  def validate_details_for(feature)
    puts "What level?" if feature == :level
    puts "Which row number?" if feature == :row
    feature_accessor = @levels if feature == :level
    feature_accessor = @rows if feature == :row
    feature_item = gets.chomp.to_i
    while feature_item < 1 || feature_item > feature_accessor
      puts "Choose a level between 1 and #{feature_accessor}"
      feature_item = gets.chomp.to_i
    end
    feature_item
  end

  def validate_space
    puts("Which space letter?")
    space = letter_to_integer(gets.downcase.chomp)
    while space < 1 || space > @spaces
      puts "Choose a space between 'a' and '#{@letter}'"
      space = letter_to_integer(gets.downcase.chomp)
    end
    space
  end

  def convert_spot(args)
    args[:level] = args[:level] - 1
    args[:row] = args[:row] - 1
    args[:space] = args[:space] - 1
    args
  end

  def get_vehicle_id
    puts "Type in the id or license number of the vehicle"
    return gets.chomp
  end

  def get_vehicle_type
    vehicle_type = -1
    while !valid_vehicle_type?(vehicle_type)
      puts "What type of vehicle would you like to add?"
      puts "Type 1 for a car, 2 for a motorcycle, 3 for a bus"
      vehicle_type = gets.chomp
    end
    vehicle_type
  end

  def valid_vehicle_type?(vehicle_type)
    vehicle_type == "1" || vehicle_type == "2" || vehicle_type == "3"
  end

  def valid_vehicle_spot(args)
    (1..@levels).include?(args[:level]) && (1..@rows).include?(args[:row]) && (1..@spaces).include?(args[:space])
  end

  def validate_spot(args)
    if @garage[args[:level]][args[:row]][args[:space]][:occupied] == false
      args[:vehicle_id] = get_vehicle_id
      add_car(args) if args[:vehicle_type] == "1"
      add_motorcycle(args) if args[:vehicle_type] == "2"
      add_bus(args) if args[:vehicle_type] == "3"
    else
      puts "That spot is occupied"
    end
  end

  def letter_to_integer(space)
    number = 0
    for i in "a"..space
      number += 1
    end
    number
  end

  def add_car(args)
    if @garage[args[:level]][args[:row]][args[:space]][:space_type] == "compact" || @garage[args[:level]][args[:row]][args[:space]][:space_type] == "large"
      @garage[args[:level]][args[:row]][args[:space]][:occupied] = true
      @garage[args[:level]][args[:row]][args[:space]][:vehicle_type] = "car"
      @garage[args[:level]][args[:row]][args[:space]][:vehicle_id] = args[:vehicle_id]
      puts "Successfully added a car."
    else
      puts "Cannot park a car there."
    end
  end

  def add_motorcycle(args)
    @garage[args[:level]][args[:row]][args[:space]][:occupied] = true
    @garage[args[:level]][args[:row]][args[:space]][:vehicle_type] = "motorcycle"
    @garage[args[:level]][args[:row]][args[:space]][:vehicle_id] = args[:vehicle_id]
    puts "Successfully added a motorcycle"
  end

  def add_bus(args)
    if bus_coordinates_in_range?(args)
      if check_for_bus_space(args)
          for i in (0..4) do
            @garage[args[:level]][args[:row]][args[:space] + i][:occupied] = true
            @garage[args[:level]][args[:row]][args[:space] + i][:vehicle_type] = "bus"
            @garage[args[:level]][args[:row]][args[:space] + i][:vehicle_id] = args[:vehicle_id]
          end
          puts "Successfully added a bus"
      else
        puts "Cannot add a bus here."
      end
    end
  end

  def check_for_bus_space(args)
    spaces = []
    for i in (0..4) do
       if @garage[args[:level]][args[:row]][args[:space] + i]
        space_type = @garage[args[:level]][args[:row]][args[:space] + i][:space_type]
      else
        space_type = "1"
       end
      spaces.push(space_type)
    end
    answer = spaces.all? {|e| e == "large"}
    answer
  end

  def remove_vehicle
    args = {}
    puts "Type the spot at which you would like to remove the vehicle."
    args = get_spot_id(args)
    args = convert_spot(args)
    validate_spot_occupied(args)
  end

  def validate_spot_occupied(args)
    if @garage[args[:level].to_i][args[:row].to_i][args[:space]][:occupied] == true
      remove_car_or_motorcycle(args) if @garage[args[:level].to_i][args[:row].to_i][args[:space]][:space_type] == "compact" ||
        @garage[args[:level].to_i][args[:row].to_i][args[:space]][:space_type] == "motorcycle"
      remove_bus(args) if @garage[args[:level].to_i][args[:row].to_i][args[:space]][:vehicle_type] == "bus"
    else
      puts "This spot is currently unoccupied"
    end
  end

  def remove_car_or_motorcycle(args)
    vehicle = @garage[args[:level]][args[:row]][args[:space]][:vehicle_type]
    @garage[args[:level]][args[:row]][args[:space]][:occupied] = false
    @garage[args[:level]][args[:row]][args[:space]][:vehicle_type] = "none"
    @garage[args[:level]][args[:row]][args[:space]][:vehicle_id] = "none"
    puts "Successfully removed the #{vehicle}"
  end

  def remove_bus(args)
    if bus_coordinates_in_range?(args)
      if check_for_bus_id(args)
        for i in (0..4) do
          @garage[args[:level]][args[:row]][args[:space] + i][:occupied] = false
          @garage[args[:level]][args[:row]][args[:space] + i][:vehicle_type] = "none"
          @garage[args[:level]][args[:row]][args[:space] + i][:vehicle_id] = "none"
        end
        puts "Successfully removed the bus"
      else
        puts "Choose the spot that starts the bus."
      end
    end
  end

  def bus_coordinates_in_range?(args)
    0 <= args[:level] && args[:level] <= @levels - 1 &&
      0 <= args[:row] && args[:row] <= @rows - 1 &&
        0 <= args[:space] && args[:space] <= @spaces - 1 &&
          0 <= args[:space] + 4 && args[:space] + 4 <= @spaces - 1
  end

  def check_for_bus_id(args)
    spaces = []
    vehicle_id = @garage[args[:level]][args[:row]][args[:space]][:vehicle_id]
    for i in (0..4) do
      if @garage[args[:level]][args[:row]][args[:space] + i][:vehicle_id]
        id = @garage[args[:level]][args[:row]][args[:space] + i][:vehicle_id]
      else
        id = "nothing"
      end
      spaces.push(id)
    end
    spaces.all? {|e| e == vehicle_id}
  end

  def print_garage
    print_level
    puts ""
    puts ""
    puts "c represents a car, b represents a bus, m represents a motorcycle"
    puts "C represents a compact spot, M represents a motorcycle spot, and L represents a large spot."
    puts ""
  end

  def print_level
    (0..@levels - 1).each do |level|
      puts ""
      puts "Level #{level + 1}"
      puts ""
      print_columns
      print_row(level)
      puts ""
    end
  end

  def print_columns
    letter = "a"
    print " "
    (0..@spaces - 1).each do
      print letter
      letter = letter.succ
    end
  end

  def print_row(level)
    (0..@rows - 1).each do |row|
      puts ""
      print "#{row + 1}"
      print_space(level, row)
    end
  end

  def print_space(level,row)
    (0..@spaces-1).each do |space|
      if @garage[level][row][space][:occupied] == true
        print "c" if @garage[level][row][space][:vehicle_type] == "car"
        print "b" if @garage[level][row][space][:vehicle_type] == "bus"
        print "m" if @garage[level][row][space][:vehicle_type] == "motorcycle"
      else
        print "C" if @garage[level][row][space][:space_type] == "compact"
        print "L" if @garage[level][row][space][:space_type] == "large"
        print "M" if @garage[level][row][space][:space_type] == "motorcycle"
      end
    end
  end

  def farewell_message
    puts 'goodbye'
  end
end