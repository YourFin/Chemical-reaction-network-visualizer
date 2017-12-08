#!/bin/env ruby
require 'gosu'

class VisualizerWindow < Gosu::Window

	def initialize
		super 640, 480
		self.caption = "CRN"

		margin = 20

 		@ballA = Molecule.new( 400, 400, { :x => -3, :y => 0 } )
		@ballB = Molecule.new( 50, 400, { :x => 3, :y => 0 } ) 

	        @score = [0, 0]
		@font = Gosu::Font.new(20)
		@counter = 0
	end
	  
	def button_down(id)
		case id
		when Gosu::KbEscape
			close
		end
   	end

	

	def update
		@ballA.update
		@ballB.update

		if @ballA.collide?(@ballB)
		   @ballA.reflect_horizontal
		   @ballB.reflect_horizontal
		elsif @ballA.x <= 0
		   @ballA.reflect_horizontal
		elsif @ballA.right >= self.width
		   @ballA.reflect_horizontal
		elsif @ballA.y <= 0
		   @ballA.reflect_vertical
		elsif @ballA.y > self.height
		   @ballA.reflect_vertical
		elsif @ballB.x <= 0
		   @ballB.reflect_horizontal
		elsif @ballB.right >= self.width
		   @ballB.reflect_horizontal
		elsif @ballB.y <= 0
		   @ballB.reflect_vertical
		elsif @ballB.y > self.height
		   @ballB.reflect_vertical
		end
	end

	def draw_background
		Gosu.draw_rect 0, 0, self.width, self.height, Gosu::Color::BLACK
	end

	def draw_score
		center_x = self.width / 2
		offset = 15
		char_width = 10
		z_order = 100
		@font.draw @score[0].to_s, center_x - offset - char_width, offset, z_order
		@font.draw @score[1].to_s, center_x + offset, offset, z_order
	end

	def draw
		draw_background
		draw_score
		@ballA.drawBall
		@ballB.drawBall
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
  WIDTH = 50
  HEIGHT = 50

  attr_reader :v
  def initialize(x, y, v)
    super(x, y, WIDTH, HEIGHT)
    @v = v
  end

  def update
    self.x += v[:x]
    self.y += v[:y]
  end

  def reflect_horizontal
     v[:x] = -v[:x]
  end

  def reflect_vertical
    v[:y] = -v[:y]
  end


  def drawBall
    Gosu.draw_rect x, y, WIDTH, HEIGHT, Gosu::Color::RED
  end
end

window = VisualizerWindow.new
window.show


