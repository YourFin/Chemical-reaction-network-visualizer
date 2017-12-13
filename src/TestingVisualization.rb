#!/bin/env ruby
require 'gosu'

class VisualizerWindow < Gosu::Window
  # creates initial window with all starting molecules
  attr_accessor :minFramesValue
  def initialize(crn)
    super 640, 480
    @crn = crn
    $CRN = crn
    self.caption = "CRN"

    @minFramesValue = @crn.reactions.map { |key, value| value[0] }.max

    margin = 20
    @balls = []
    small = crn.species_list.reduce { | old, nn |  (nn.initial_count < old.initial_count && nn.initial_count > 0.0 ) ? nn : old }.initial_count
    for species in crn.species_list
      species.initial_count = (species.initial_count / small * $NUM_MIN).floor
      for ii in (0..species.initial_count)
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
          if doWeBreak
            break
          end
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
    for molecule in balls
      molecule.update(self)
    end
  end

  # changes velcoity for when molecules bounce off of walls
  def colliWall_h(balls)
    for molecule in balls
      if molecule.x <= 0 || molecule.right >= self.width
        molecule.reflect_horizontal
      elsif molecule.y <= 0 || molecule.bottom >= self.height
        molecule.reflect_vertical
      end
    end
  end	

  def split(balls, substrates, product_species)
    for substrate in substrates
      balls.delete(substrate)
    end
    ret = []
    for product in product_species
      mol = Molecule.new(product, substrates[0].x, substrates[0].y,
                         { :x => rand($MAX_VELOCITY) * ((-1)**rand(2)),
                           :y => rand($MAX_VELOCITY) * ((-1)**rand(2))})
      ret.push(mol)
    end #for
    for mol in ret
      mol.noCollideList = ret - [mol]
    end
    return ret
  end

  # action to be taken when molecules colide and bounce
  def colliBall_h(balls)
    for molecule, mol_col_chk in balls.combination(2)
      if mol_col_chk.collide?(molecule) && (! molecule.noCollideList.include?(mol_col_chk))
        if @crn.reactions.key?([molecule.species, mol_col_chk.species]) 
          @balls += split(@balls, [molecule, mol_col_chk], @crn.reactions[[molecule.species, mol_col_chk.species]][1])
        else  
          #bounce around when it is not a reaction
          temp = Marshal.load(Marshal.dump(molecule.v))
          molecule.v = Marshal.load(Marshal.dump(mol_col_chk.v))
          mol_col_chk.v = temp
        end #no coList
      else
        molecule.noCollideList = molecule.noCollideList - [mol_col_chk]
        mol_col_chk.noCollideList = mol_col_chk.noCollideList - [molecule]
      end # if collide
    end #for
  end




  # calls individual update functions to move the balls, check for wall colisions, and check for collisions between molecules
  def update
    update_h(@balls)
    colliBall_h(@balls)
    colliWall_h(@balls)
  end

  # draws the background of the visualizer
  def draw_background
    Gosu.draw_rect 0, 0, self.width, self.height, Gosu::Color::BLACK
  end

  # draws the balls (AKA molecules)
  def draw_h(balls)
    for molecule in balls
      molecule.drawBall
    end
  end

  # calls the individual draw functions for the background, balls (molecules), and score
  def draw
    draw_background
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
    @x
  end

  def right
    @x + @w
  end

  # purpose
  # calculate x coordinate of the left side of object by subtracting the width from the right most x value
  def right=(r)
    @x = r - @w
  end

  def top
    @y
  end

  # purpose
  # calculate uppermost coordinate by subtracting the width from the right most x value
  def top=(t)
    @y = t
  end

  def bottom
    @y + @h
  end

  def center_y
    @y + @h/2
  end

  def center_x
    @x + @x/2
  end

  def bottom=(b)
    @y = b - @h
  end

  # determines whether two objects have colided
  def collide?(other)
    max_left = [left, other.left].max
    max_top = [top, other.top].max
    min_right = [right,other.right].min
    min_bottom = [bottom,other.bottom].min
    return max_left <= min_right && max_top <= min_bottom
  end
end

# To Do:
#change how color is chosen
#change how reflection is determined
#make the starting x and y random
#make initial velocity random
class Molecule < GameObject
  attr_accessor :noCollideList

  # attribute
  # v: the velocity
  attr_accessor :v, :species
  def initialize(species, x, y, vv, noCollideList = [])
    super(x, y, $BALL_SIZE, $BALL_SIZE)
    @v = vv
    @species = species
    @noCollideList = noCollideList
  end

  # used velocity to change the x and y position
  def update(visualizer)
    #check for spontaneous splits
    for _, value in $CRN.reactions.select { |key, val| key == [self] }
      if rand($MIN_TICS / visualizer.minFramesValue * value[0]).round == 0
        visualizer.split([self], value[1])
      end
    end
    self.x += self.v[:x]
    self.y += self.v[:y]
  end

  # used in colitions: to change x direction by 180 degrees
  def reflect_horizontal
    self.v[:x] = -self.v[:x]
  end

  # used in colitions: to change y direction by 180 degrees
  def reflect_vertical
    self.v[:y] = -self.v[:y]
  end

  # function to draw the ball (Molecule)
  def drawBall
    Gosu.draw_rect @x, @y, $BALL_SIZE, $BALL_SIZE, @species.color
  end
end
