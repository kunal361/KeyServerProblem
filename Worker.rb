require_relative 'DB'

class Worker
  
  attr_writer :kill

  def initialize
    @kill = false
  end

  def start
    Thread.new do
      while !@kill do
        puts "Working!!"
        rel_bkeys
        rel_ukeys
        sleep 1
      end
    end
  end

  def rel_bkeys #releases blocked keys, that have been blocked for 60secs or more, and makes them available.
    $blocked.each do |key|
      if Time.now - $time_stamp[key] >= 60
        puts "#{key} is now available!"
        $blocked.delete(key)
        $available.add(key)
        $time_stamp[key] = Time.now
      end
    end
  end

  def rel_ukeys #deletes unused keys, that are available and have not been used for 5minutes(300 seconds) or more
    $available.each do |key|
      if Time.now - $time_stamp[key] >= 300
        puts "#{key} is deleted!"
        $available.delete(key)
        $time_stamp.delete(key)
      end
    end
  end

end
