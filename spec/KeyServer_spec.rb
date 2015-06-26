require_relative 'spec_helper'
require_relative '../DB'

describe KeyServer do
  
  before :all do
    @server = KeyServer.new
    @server.key_gen
    @key = @server.get_key
  end

  describe '#new' do

    it 'returns a KeyServer Object' do
      expect(@server).to be_an_instance_of KeyServer
    end

  end

  describe '#key_gen' do
  
    it 'creates a key' do
      @server.key_gen
      expect($available.size).not_to eql 0
    end
  
  end

  describe '#get_key' do

    it 'gets a key and blocks it' do
      expect(@server.get_key).not_to eql nil
      expect($available.size).to eql 0
    end

  end

  describe '#unblock' do

    it 'unblocks a blocked key' do
      expect(@server.unblock(@key)).to eql true
    end

  end

  describe '#keep_alive' do

    it 'keeps a key alive for 5 more minutes' do
      expect(@server.keep_alive(@key)).to eql true
    end

  end

  describe '#delete' do

    it 'deletes a key' do
      expect(@server.delete(@key)).to eql true
    end

  end

  after :all do
    @server.worker.kill = true
  end

end