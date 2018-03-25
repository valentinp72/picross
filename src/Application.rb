#!/usr/bin/env ruby
# encoding: utf-8

##
# File          :: Chapter.rb
# Author        :: PELLOIN Valentin
# Licence       :: MIT License
# Creation date :: 03/25/2018
# Last update   :: 03/25/2018
# Version       :: 0.1
# This is the main program to execute to start the application.

require_relative 'UI/Application'

application = Application.new
application.run([$0]+ARGV)
