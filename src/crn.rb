#!/bin/env ruby

import 'gosu'

class molecule
  def initialize(x_pos, y_pos, x_vel, y_vel)
    @x_start_pos = x_pos
    @y_start_pos = y_pos
    @x_start_vel = x_vel
    @y_start_vel = y_vel
    @x_pos = x_pos
    @y_pos = y_pos
    @x_vel = x_vel
    @y_vel = y_vel
    @bouncelist = []
  end
  def initialize(x_pos, y_pos, x_vel, y_vel, bouncelist)
    initialize(x_pos, y_pos, x_vel, y_vel)
    @bouncelist = bouncelist
  end
end
