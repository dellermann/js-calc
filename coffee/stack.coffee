#
# stack.coffee
#
# Copyright (c) 2014, Daniel Ellermann
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
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

