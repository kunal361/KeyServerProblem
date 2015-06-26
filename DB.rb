require 'sinatra'
require 'set'

$available = Set.new

$blocked = Set.new

$time_stamp = Hash.new
