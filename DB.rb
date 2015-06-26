require 'sinatra'
require 'set'

$available = Set.new #set of available keys

$blocked = Set.new #set of blocked keys

$time_stamp = Hash.new #hash containing time stamps of all the keys
