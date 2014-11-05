#
# stack.coffee
#
# Copyright (c) 2014, Daniel Ellermann
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#


# Class `Stack` represents a generic stack which is used by the calculator to
# store the values of the registers.
#
# @author   Daniel Ellermann
# @version  0.9
# @since    0.9
#
class Stack

  #-- Constructor -------------------------------

  # Creates an empty stack.
  #
  constructor: ->
    @stack = []


  #-- Public methods ----------------------------

  # Clears all elements from the stack.
  #
  clear: ->
    @stack = []

  # Duplicates the value on top of the stack.
  #
  # @return [Number]  the new size of the stack
  #
  duplicate: ->
    s = @stack
    n = s.length
    s.push s[n - 1] if n > 0

  # Checks whether or not the stack is empty, that is, does not contain any
  # elements.
  #
  # @return [Boolean] `true` if the stack is empty; `false` otherwise
  #
  isEmpty: ->
    @size() == 0

  # Returns the value on top of the stack without removing it.
  #
  # @return [Object]  the value on top of the stack
  # @see    #pop()
  #
  peek: ->
    s = @stack
    n = s.length
    if n > 0 then s[n - 1] else `undefined`

  # Removes and returns the value on top of the stack decreasing the size of
  # the stack by one.
  #
  # @return [Object]  the value on top of the stack
  # @see    #peek()
  #
  pop: ->
    @stack.pop()

  # Pushes on or more values on top of the stack.
  #
  # @param [Object...] values the values that should be pushed on the stack
  # @return [Number]          the new size of the stack
  #
  push: (values...) ->
    @stack.push value for value in values

  # Changes the value on top of the stack.  If the stack is empty the given
  # value is pushed on top of the stack.
  #
  # @param [Object] value the value that should be stored on top of the stack
  # @return [Object]      the former value on top of the stack; `undefined` if the stack was empty
  #
  setTop: (value) ->
    s = @stack
    res = `undefined`
    n = s.length
    if n > 0
      res = s[n - 1]
      s[n - 1] = value
    else
      s[0] = value
    res

  # Gets the size, that is, the number of elements, on the stack.
  #
  # @return [Number]  the size of the stack
  #
  size: ->
    @stack.length

