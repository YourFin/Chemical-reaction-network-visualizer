#!/usr/bin/env ruby

require 'optparse'
require './src/crn.rb'
require './src/TestingVisualization.rb'

options = {}

OptionParser.new do |opts|
  opts.banner = "Usage: CRNvisualizer CRN_TO_VISUALIZE.cps [OPTIONS]"
  opts.separator  ""
  opts.separator  "Options:"
  opts.on("-h", "--help", "Display this message and exit.") do
    puts opts
    exit
  end
end.parse!

def invalidArguments()
  puts "Invalid arguments; try 'CRNvisualizer --help' for help"
  exit 1
end

#begin
  crn = CRN.parseFromCPSFile(ARGV[0])
#rescue
#  puts 'Invalid CPS file'
#  invalidArguments
#end


window = VisualizerWindow.new(crn)
window.show
