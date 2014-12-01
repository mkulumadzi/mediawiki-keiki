# require 'minitest/spec'
# require 'minitest/autorun'
# require 'rubygems'
# require_relative 'cr3wler.rb'

# describe Cr3wler do

# 	before do
# 		input = File.new("test_input.csv", "w")
# 		output = File.new("test_output.tsv", "w")
# 		input << "Wikipedia"
# 		innput.clos
# 		output.close
# 		@test_cr3wler = Cr3wler.new('test_input.csv', 'test_output.tsv')
# 	end

# 	it "has sources in an array" do
# 		@test_cr3wler.sources.must_be_instance_of Array
# 	end

# 	it "has an array of sites" do
# 		@test_cr3wler.sites.must_be_instance_of Array
# 	end

# 	it "has a results file" do
# 		@test_cr3wler.result.must_be_instance_of File
# 	end

# end