#!/bin/env ruby
require 'gosu'

class VisualizerWindow < Gosu::Window

	def initialize
		super 640, 480
		self.caption = "CRN"

		margin = 20
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
	
	def draw
		draw_background
		draw_score
	end

	def draw_background
		Gosu.draw_rect 0, 0, self.width, self.height, Gosu::Color::WHITE
	end

	def draw_score
		center_x = self.width / 2
		offset = 15
		char_width = 10
		z_order = 100
		@font.draw score[0].to_s, center_x - offset - char_width, offset, z_order
		@font.draw score[1].to_s, center_x + offset, offset, z_order
	end
end

window = VisualizerWindow.new
window.show


