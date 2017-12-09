#!/bin/env ruby
require 'gosu'

class VisualizerWindow < Gosu::Window

	def initialize
		super 640, 480
		self.caption = "CRN"

		margin = 20

 		@ballA = Molecule.new( 300, 375, { :x => -3, :y => 0 } )
		@ballB = Molecule.new( 50, 400, { :x => 3, :y => 0 } ) 
		@balls = [@ballA, @ballB]

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

	def update_h(balls)
		for molecule in balls do
		   molecule.update
		end
	end

	def colliWall_h(balls)
		for molecule in balls do
		   if molecule.x <= 0 || molecule.right >= self.width
		  	 molecule.reflect_horizontal
		   elsif molecule.y <= 0 || molecule.y > self.height
		   	molecule.reflect_vertical
		   end
		end
	end	

	def colliBall_h(balls)
		for molecule in balls do 
			for mol_col_chk in balls.select { |mol| mol != molecule } do
		   		if mol_col_chk.collide?(molecule)
					molecule.reflect_horizontal
					#mol_col_chk.reflect_horizontal
				end
			end
		end
	end

	def update
		update_h(@balls)
		colliBall_h(@balls)
		colliWall_h(@balls)
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

	def draw_h(balls)
		for molecule in balls do
		   molecule.drawBall
		end
	end

	def draw
		draw_background
		draw_score
		draw_h(@balls)
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


