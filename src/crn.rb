#!/bin/env ruby

require 'gosu'

class CRN
  def initialize()
    @species_list = []
    @molecules = []
    @reactions = {}
  end
end

class Species
  def initialize(name, inital_count, color = Gosu::Color.from_hsv(Random.rand(360), 1, 1))
  end
end

class Molecule
  def initialize(x_pos, y_pos, x_vel, y_vel, species, bouncelist=[])
  end
end
