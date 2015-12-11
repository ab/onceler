require 'securerandom'

module Onceler
  class Cache
    KeyChars = ('a'..'z').to_a + ('0'..'9').to_a

    def self.random_char
      KeyChars[SecureRandom.random_number(KeyChars.length)]
    end
    def self.random_key(length=30)
      (0...length).map { random_char }.join
    end

    def initialize
      @data = {}
    end

    def length
      @data.length
    end

    alias :size :length

    def get(key)
      @data[key] or raise IndexError.new("key #{key.inspect} not found")
    end

    def delete(key)
      @data.delete(key) or raise IndexError.new("key #{key.inspect} not found")
    end

    def add_entry(entry)
      @data[entry.key] = entry
    end

    def add_by_key(key, value)
      @data[key] = value
    end

    def add_random(value)
      key = self.class.random_key
      add_by_key(key, value)
      key
    end
  end
end
