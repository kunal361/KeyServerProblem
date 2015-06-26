require 'set'
require_relative 'Worker'

require "securerandom"

class KeyServer

  attr_reader :worker

  def initialize
    @worker = Worker.new
    @worker.start
  end
  
  def key_gen #generates a unique key
    key = SecureRandom.uuid
    $available.add(key)
    $time_stamp[key] = Time.now
    return true
  end

  def get_key #returns an unblocked key if available, else returns nil
    if $available.length != 0
      key = $available.take(1)[0]
      $available.delete(key)
      $blocked.add(key)
      $time_stamp[key] = Time.now
      return key
    else
      return false
    end
  end

  def keep_alive(key) #changes the key's time stamp
    ret = false
    if $available.include?(key)
      $time_stamp[key] = Time.now
      ret = true
    elsif $blocked.include?(key)
      $time_stamp[key] = Time.now
      ret = true
    end
    return ret
  end

  def unblock(key) #unblocks a key, ie. moves it from blocked state to available state
    if $blocked.include?(key)
      $blocked.delete(key)
      $available.add(key)
      return true
    else
      return false
    end
  end

  def delete(key) #deletes a particular key
    if $available.include?(key)
      $available.delete(key)
      $time_stamp.delete(key)
      return true
    elsif $blocked.include?(key)
      $blocked.delete(key)
      $time_stamp.delete(key)
      return true
    else
      return false
    end
  end

end
