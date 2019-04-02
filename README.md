# Parking Garage
## Author: Tim Fielder
## Date: 04.01.18
## Version: 1.0

## Basic Information
* This code simulates a parking garage from the CLI.

* The garage is setup to create "large" spots on the last row and "motorcycle" spots in the first row.
* All remaining spots are compact spots.

## Getting Started
* To get started, make sure you have a version of Ruby downloaded to your computer. 2.4.0 or higher. (This project was created using 2.4.1)
* From the CLI, clone the repository to the directory of your choice.
* Open the cloned directory.
* Run ruby lib/run_parking_garage.rb
* Follow the instructions or type 'q' to quit.

## Testing
To view tests, do the following:
* Make sure the files are downloaded (see getting started for more).
* From the CLI, run ruby test/parking_garage_test.rb

## The code adheres to the following rules:
1. The parking garage has multiple levels. Each level has multiple rows of spots. 
2. The parking garage can park motorcycles, cars, and buses. 
3. The parking garage has motorcycle spots, compact spots, and large spots. 
4. A motorcycle can park in any spot. 
5. A car can park in either a single compact spot or a single large spot. 
6. A bus can park in five large spots that are consecutive and within the same row. It cannot park in small spots. 