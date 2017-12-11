#!/bin/env ruby
require 'gosu'

class VisualizerWindow < Gosu::Window

  #  attr_reader : CRN
  #  attr_reader : Species

  def initialize(crn)
    super 640, 480
    self.caption = "CRN"

    margin = 20

    @ballA = Molecule.new( 100, 100, { :x => 4, :y => 4 } )
    @ballB = Molecule.new( 50, 50, { :x => 3, :y => -3 } ) 

    for species in 

    #    @score = [0, 0]
    @font = Gosu::Font.new(20)
    @flash = {}
    @counter = 0
  end

  def button_down(id)
    case id
    when Gosu::KbEscape
      close
    end
  end

  #Checks to see if there are collisions with with walls and reflects the velocities accordingly
  def update
    @ballA.update
    if @ballA.collide?(@ballB)
      @ball.reflect_horizontal
    #     increase_speed
    elsif @ball.collide?(@enemy)
      # play sound
      @ball.reflect_horizontal
      @blip_sound.play
      increase_speed
    elsif @ball.x <= 0
      @ball.reflect_horizontal #add
      score[1] += 1
    elsif @ball.right >= self.width
      @ball.reflect_horizontal #add
      score[0] += 1

    end

    @ball.reflect_vertical if @ball.y < 0 || @ball.bottom > self.height
  end

  def increase_speed
    @ball.v[:x] = @ball.v[:x] * 1.1
  end

  #  def flash_side(side)
  #    @flash[side] = true
  #  end

  def draw
    draw_background

    #    if @flash[:left]
    #      Gosu.draw_rect 0, 0, self.width / 2, self.height, Gosu::Color::RED
    #      @flash[:left] = nil
    #    end

    #    if @flash[:right]
    #      Gosu.draw_rect self.width / 2, 0, self.width, self.height, Gosu::Color::RED
    #      @flash[:right] = nil
    #    end

    #   draw_center_line
    draw_score
    @player.draw
    @enemy.draw
    @ball.draw
  end

  def draw_background
    Gosu.draw_rect 0, 0, self.width, self.height, Gosu::Color::WHITE
  end

  #  def draw_center_line
  #    center_x = self.width / 2
  #    segment_length = 10
  #    gap = 5
  #    color = Gosu::Color::GREEN
  #    y = 0
  #    begin
  #      draw_line center_x, y, color,
  #                center_x, y + segment_length, color
  #      y += segment_length + gap
  #    end while y < self.height
  #  end

  def draw_score
    center_x = self.width / 2
    offset = 15
    char_width = 10
    z_order = 100
    @font.draw score[0].to_s, center_x - offset - char_width, offset, z_order
    @font.draw score[1].to_s, center_x + offset, offset, z_order
  end
end

class GameObject
  attr_accessor :x
  attr_accessor :y
  attr_accessor :w
  attr_accessor :h

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

  def right=(r)
    self.x = r - w
  end

  def top
    y
  end

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
  WIDTH = 10
  HEIGHT = 10

  attr_reader :v
  def initialize(x, y, v)
    super(x, y, WIDTH, HEIGHT)
    @v = v
  end

  def update
    self.x += v[:x]
    self.y += v[:y]
  end
  
  #change so that it reflects by the reflection factor 
  def reflect_horizontal
    v[:x] = -v[:x]
  end

  def reflect_vertical
    v[:y] = -v[:y]
  end

  def draw
    Gosu.draw_rect x, y, WIDTH, HEIGHT, Gosu::Color::RED
  end
end


#window = VisualizerWindow.new
#window.show
