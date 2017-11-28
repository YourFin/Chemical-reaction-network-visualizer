#!/bin/env ruby

require 'gosu'

# Class
  # - CRN: defining the chemical reaction network
# Instance Variable:
  # - species_list: the list of all of the species that could be in this CRN (inputs to the system and the outputs of the reactions)
  # - molecules: the list of species currently in the simulation
  # - reactions: [rate constant, [reaction product(s)]]
  #              key: list of reactants
  #              value: list containting rate constant and a list of the output(s) of the reactions             
class CRN
  def initialize()
    @species_list = []
    @molecules = []
    @reactions = {}
  end
end

# Class
  # - Species: defining the chemical reaction network
# Instance Variable:
  # - name: name of the species
  # - initinal_count: the initial number of this species
  # - color: the color of this species; randomly obtained from Gosu
class Species
  def initialize(name, inital_count, color = Gosu::Color.from_hsv(Random.rand(360), 1, 1))
  end
end

# Class
  # - Molecule: defining the chemical reaction network
# Instance Variable:
  # - x_pos: current x position
  # - y_pos: current y position
  # - x_vel: the velocity in the x direction
  # - y_vel: the velocity in the y direction
  # - bouncelist: a list logging all of molecules bouncing off of the walls of the container and their new angle
class Molecule
  def initialize(x_pos, y_pos, x_vel, y_vel, species, bouncelist=[])
  end
end
