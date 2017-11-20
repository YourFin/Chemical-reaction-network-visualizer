#!/bin/env ruby

require 'gosu'
require 'random'

class Species
  def initialize(name, initial_count)
    initialize(name, initial_count, Gosu::Color.from_hsv(Random.rand(360), 1, 1))
  end
  def initialize(name, inital_count, color = "")
  end
end

class Molecule
  def initialize(x_pos, y_pos, x_vel, y_vel, species)
    initialize(x_pos, y_pos, x_vel, y_vel, species, [])
  end
  def initialize(x_pos, y_pos, x_vel, y_vel, species, bouncelist)
  end
end
