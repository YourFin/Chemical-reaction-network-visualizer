#!/bin/env ruby

require 'gosu'
require 'nokogiri'

# Class
# - CRN: defining the chemical reaction network
# Instance Variable:
# - species_list: the list of all of the species that could be in this CRN (inputs to the system and the outputs of the reactions)
# - molecules: the list of species currently in the simulation
# - reactions: [rate constant, [reaction product(s)]]
#              key: list of reactants
#              value: list containting rate constant and a list of the output(s) of the reactions             
class CRN
  attr_accessor :species_list, :molecules, :reactions
  def initialize()
    @species_list = []
    @molecules = []
    @reactions = {}
  end

  def CRN.parseFromCPSFile(filename)
    doc = File.open(filename) { |f| Nokogiri::XML(f) }
    retCRN = CRN.new

    ### Parse Species
    # Grab initial values for species
    initial_state_numbers =
      (doc.xpath('//xmlns:Model[@type="deterministic"]') > "InitialState") .to_s().lines[1].split(" ").map { |ii| ii.to_f }
    initial_state_names =
      (doc.xpath('//xmlns:Model[@type="deterministic"]') > "StateTemplate").to_s.lines.map {
      |v| v.match('".*"').to_s[1..-2] }[1..-2]
    initial_state_dict = {}
    initial_state_names.each_with_index do | name, index |
      initial_state_dict[name] = initial_state_numbers[index]
    end

    # Convert metabolites from the list of metabolites into
    # species
    count = 0
    key_dict = {}
    for metabolite in (doc.xpath('//xmlns:Model[@type="deterministic"]').first > "ListOfMetabolites").children do
      if metabolite.has_attribute?("name") then
        key_dict[metabolite.attribute("key").to_s] = metabolite.attribute("name").to_s
        retCRN.species_list.push(Species.new(
                                   metabolite.attribute("name").to_s,
                                   initial_state_dict[metabolite.attribute("key").to_s]))
      end
    end

    ### Reactions
    for reaction in (doc.xpath('//xmlns:Model[@type="deterministic"]').first > "ListOfReactions").children.select { |rr| rr.keys.count > 0 } do
      #Grab substrates
      substrates = (reaction > "ListOfSubstrates").children.map { |substrate| substrate.attribute("metabolite").to_s }.select{|aa| aa != ""}
      #Grab products
      products = (reaction > "ListOfProducts").children.map { |product| product.attribute("metabolite").to_s }.select{|aa| aa != ""}
      #Map keys back to their names, as we don't care
      #about keys as COPASI defines them
      substrates = substrates.map { |substrate| key_dict[substrate] }
      products = products.map { |product| key_dict[product] }
      constant = (reaction > "ListOfConstants").children
                   .select { |element| element.keys.count > 0 } # Remove empty nodes
                   .first.attribute("value") # We only care about one constant for the reaction
                   .to_s.to_f
      retCRN.reactions[substrates] = [constant, products]
      retCRN.reactions[substrates.reverse] = [constant, products]
    end
    return retCRN
  end
end

# Class
  # - Species: defining the chemical reaction network
# Instance Variable:
  # - name: name of the species
  # - initinal_count: the initial number of this species
  # - color: the color of this species; randomly obtained from Gosu
  # - species_count: a running list of the count of each species - for the purpose of recreating the simmulation
class Species
  attr_accessor :name, :initial_count, :color, :species_count
  def initialize(name, initial_count, color = Gosu::Color.from_hsv(Random.rand(360), 1, 1))
    @name = name
    @initial_count = initial_count
    @color = color
    @species_count = []
  end
  def to_s()
    return "#<Species name: #{@name}, count: #{@initial_count}>"
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
