require_relative 'spec_helper'
require_relative '../DB'

describe Worker do
  
  before :all do
    
    @worker = Worker.new
    key = "RandomUniqueString1"
    $blocked.add(key)
    $time_stamp[key] = Time.now - 60

    key = "RandomUniqueString2"
    $available.add(key)
    $time_stamp[key] = Time.now - 301

    key = "RandomUniqueString3"
    $blocked.add(key)
    $time_stamp[key] = Time.now

  end

  describe '#new' do
    
    it 'creates a worker object' do
      expect(@worker).to be_an_instance_of Worker
    end
  
  end

  describe '#rel_bkeys' do
    
    it 'releases blocked keys' do
      count = $available.length
      @worker.rel_bkeys
      expect($available.length).to eql(count + 1)
    end

  end

  describe '#rel_ukeys' do

    it 'deletes available keys' do
      count = $available.length
      @worker.rel_bkeys
      sleep 1
      expect($available.length).to eql(count - 1)
    end

  end

  describe '#start' do

    it 'runs indefinitely to check for blocked and expired keys' do
      
      @worker.start
      sleep 61
      expect($blocked.size).to eql 0
      expect($available.size).not_to eql 0
      sleep 301
      expect($available.size).to eql 0

    end

  end

  after :all do
    @worker.kill = true
  end

end