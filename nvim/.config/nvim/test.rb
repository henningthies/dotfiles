# frozen_string_literal: true

# This is a test class
class Foo
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def display_name
    "name: #{name}"
  end
end

foo = Foo.new(name)
foo.display_name
