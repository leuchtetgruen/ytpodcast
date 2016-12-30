require 'json'

class Cache

  include Singleton

  def initialize(filename="cache.json")
    @filename = filename
    load
  end

  def load
    @hash = if File.exist?(@filename)
             JSON.parse(File.read(@filename))
           else
             {}
           end
  end

  def save
    File.write(@filename, @hash.to_json)
  end

  def []=(id, filename)
    @hash[id] = filename
  end

  def [](id)
    @hash[id]
  end

  def has?(id)
    @hash.keys.map(&:to_s).include?(id)
  end
end
