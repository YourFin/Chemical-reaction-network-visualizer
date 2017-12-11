#!/usr/bin/env ruby

require 'optparse'
require './src/crn.rb'
require './src/TestingVisualization.rb'

def invalidArguments()
  puts "Invalid arguments; try 'CRNvisualizer --help' for help"
  exit 1
end

$MAX_VELOCITY = 3
$BALL_SIZE = 10
$NUM_MIN = 2

OptionParser.new do |opts|
  opts.banner = "Usage: CRNvisualizer CRN_TO_VISUALIZE.cps [OPTIONS]"
  opts.separator  ""
  opts.separator  "Options:"
  opts.on("-h", "--help", "Display this message and exit.") do
    puts opts
    exit
  end
  opts.on("-ms", "--mol-size INT", Integer, "The width of a molecule, in pixels. Default 10.") do |ms|
    invalidArguments if ms < 0
    $BALL_SIZE = ms
  end
  opts.on("-n", "--num-min INT", Integer, "The number of molecules for the reactant with the smallest non-zero initial value. Default two.") do | nn |
    puts nn.class
    if nn < 1
      invalidArguments
    end
    $NUM_MIN = nn
  end
  opts.on("-mv", "--max-velocity FLOAT", Float, "The maximum velocity of a particles") do |mv|
    
  end
end.parse!


#begin
  crn = CRN.parseFromCPSFile(ARGV[0])
#rescue
#  puts 'Invalid CPS file'
#  invalidArguments
#end

window = VisualizerWindow.new(crn)
window.show
