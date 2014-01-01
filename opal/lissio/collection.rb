#--
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.
#++

require 'forwardable'

module Lissio

class Collection
	def self.adapter(klass = nil, *args, &block)
		if klass
			@adapter.uninstall if @adapter

			@adapter = klass.new(self, *args, &block)
			@adapter.install
		else
			@adapter
		end
	end

	def self.model(klass = nil)
		klass ? @model = klass : @model
	end

	def self.parse(&block)
		block ? @parse = block : @parse
	end

	include Enumerable

	extend Forwardable
	def_delegators :class, :adapter, :model
	def_delegators :@items, :empty?, :length, :[], :to_a

	def initialize(data = nil, *fetched_with)
		@fetched_with = fetched_with

		if data
			if block = self.class.parse
				@items = block.call(data)
			else
				@items = data.map {|datum|
					model.new(datum)
				}
			end
		end
	end

	def replace(array)
		@items = array

		self
	end

	def each(&block)
		return enum_for :each unless block

		@items.each(&block)

		self
	end

	def inspect
		"#<#{self.class.name}: #{@items.inspect}>"
	end
end

end
