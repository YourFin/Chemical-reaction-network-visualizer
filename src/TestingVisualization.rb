#!/bin/env ruby
require 'gosu'

class VisualizerWindow < Gosu::Window
  # creates initial window with all starting molecules
  def initialize(crn)
    super 640, 480
    @crn = crn
    self.caption = "CRN"

    margin = 20
    #read the CRN file and build initial balls
    #@ballA = Molecule.new( 300, 375, { :x => -3, :y => 0 } )
    #@ballB = Molecule.new( 50, 400, { :x => 3, :y => 0 } ) 
    #@balls = [@ballA, @ballB]
    @balls = []
    small = crn.species_list.reduce { | old, nn |  (nn.initial_count < old.initial_count && nn.initial_count > 0.0 ) ? nn : old }.initial_count
    puts small
    for species in crn.species_list do
      species.initial_count = (species.initial_count / small * $NUM_MIN).floor
      for ii in (0..species.initial_count) do
        ballt = nil
        loop do	
          ballt = Molecule.new(species, rand(640), rand(480), 
           { :x => rand($MAX_VELOCITY) * ((-1)**rand(2)), 
             :y => rand($MAX_VELOCITY) * ((-1)**rand(2))})
          doWeBreak = true
          for ball in @balls
            if ball.collide?(ballt) then
              doWeBreak = nil
              break
            end
          end
          break if doWeBreak  
        end  
        @balls.push ballt
      end
    end
    @score = [0, 0]
    @font = Gosu::Font.new(20)
    @counter = 0
  end

# code to close window when esc key pressed
def button_down(id)
  case id
  when Gosu::KbEscape
    close
  end
end

#function call to update the balls each frame update
# molecules actions include: moving, reacting, bouncing (off walls or other molecules)
def update_h(balls)
  for molecule in balls do
    molecule.update
  end
end

# changes velcoity for when molecules bounce off of walls
def colliWall_h(balls)
  for molecule in balls do
    if molecule.x <= 0 || molecule.right >= self.width
      molecule.reflect_horizontal
    elsif molecule.y <= 0 || molecule.y > self.height
      molecule.reflect_vertical
    end
  end
end	

# action to be taken when molecules colide and bounce
def colliBall_h(balls)
  for molecule in balls do 
    #
    for mol_col_chk in balls.select { |mol| mol != molecule } do
      if mol_col_chk.collide?(molecule)
        if @crn.reactions.key?([molecule, mol_col_chk])
          balls.delete(molecule)
          balls.delete(mol_col_chk)
          
        else
          #bounce
        end
      end
    end
  end
end

# calls individual update functions to move the balls, check for wall colisions, and check for collisions between molecules
def update
  puts "update"
  update_h(@balls)
  colliBall_h(@balls)
  colliWall_h(@balls)
end

# draws the background of the visualizer
def draw_background
  puts "awe"
  Gosu.draw_rect 0, 0, self.width, self.height, Gosu::Color::BLACK
  puts "all"
end

# draws a score (to be changed)
def draw_score
  center_x = self.width / 2
  offset = 15
  char_width = 10
  z_order = 100
  @font.draw @score[0].to_s, center_x - offset - char_width, offset, z_order
  @font.draw @score[1].to_s, center_x + offset, offset, z_order
end

# draws the balls (AKA molecules)
def draw_h(balls)
  puts "orange"
  for molecule in  balls do
    molecule.drawBall
  end
end

# calls the individual draw functions for the background, balls (molecules), and score
def draw
  puts "potato"
  draw_background
  puts "apple"
  draw_score
  draw_h(@balls)
end
end

# class: GameObject
# defines a object (entity with properties and actions) for the program (ie, the molecules)
class GameObject
  attr_accessor :x
  attr_accessor :y
  attr_accessor :w
  attr_accessor :h

  # parameters
  # x: x value of upper right hand side of object
  # y: y value of upper right hand side of object
  # w: width
  # h: height
  def initialize(x, y, w, h)
    @x = x
    @y = y
    @w = w
    @h = h
  end

  def left
    x
  end

  def right
    x + w
  end

  # purpose
  # calculate x coordinate of the left side of object by subtracting the width from the right most x value
  def right=(r)
    self.x = r - w
  end

  def top
    y
  end

  # purpose
  # calculate uppermost coordinate by subtracting the width from the right most x value
  def top=(t)
    self.y = t
  end

  def bottom
    y + h
  end

  def center_y
    y + h/2
  end

  def center_x
    x + x/2
  end

  def bottom=(b)
    self.y = b - h
  end

  # determines whether two objects have colided
  def collide?(other)
    x_overlap = [0, [right, other.right].min - [left, other.left].max].max
    y_overlap = [0, [bottom, other.bottom].min - [top, other.top].max].max
    x_overlap * y_overlap != 0
  end
end

# To Do:
#change how color is chosen
#change how reflection is determined
#make the starting x and y random
#make initial velocity random
class Molecule < GameObject
  WIDTH = $BALL_SIZE
  HEIGHT = $BALL_SIZE

  # attribute
  # v: the velocity
  attr_reader :v
  def initialize(species, x, y, v)
    super(x, y, WIDTH, HEIGHT)
    @v = v
    @species = species
  end

  # used velocity to change the x and y position
  def update
    self.x += v[:x]
    self.y += v[:y]
  end

  # used in colitions: to change x direction by 180 degrees
  def reflect_horizontal
    v[:x] = -v[:x]
  end

  # used in colitions: to change y direction by 180 degrees
  def reflect_vertical
    v[:y] = -v[:y]
  end

  def split()
  end

  # function to draw the ball (Molecule)
  def drawBall
    puts @species.color
    Gosu.draw_rect x, y, WIDTH, HEIGHT, @species.color
  end
end


