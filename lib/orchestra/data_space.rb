module Orchestra
  module DataSpace
    def self.included( base )
      class << base
        attr_accessor :dataspace_primary_key
      end
      base.dataspace_primary_key = :pk
    end

    attr_accessor :id

    def initialize( attributes = {} )
      self.attributes = attributes
    end

    def attributes=( attributes )
      attributes.each do |field, value|
        set( field, value )
      end
    end

    def attributes
      @attributes ||= {}
    end

    def set( field, value )
      if field.to_sym == self.class.dataspace_primary_key
        self.id = normalize_primary_key(value)
      else
        attributes[field.to_s] = value
      end
    end
    alias :[]= :set

    def get( field )
      attributes[field.to_s]
    end
    alias :[] :get

    private
    def method_missing(method, *args)
      if attributes.keys.include?( method.to_s )
        get( method )
      elsif matches = method.to_s.match(/^([a-zA-Z0-9\_]+)=$/)
        set( matches[1], *args )
      else
        super( method, *args )
      end
    end

    def normalize_primary_key( value )
      value.to_s.gsub(/^[a-zA-Z\_]+:/, '').to_i
    end
  end
end
