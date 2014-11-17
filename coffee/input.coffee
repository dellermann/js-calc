#
# input.coffee
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


class Input

  #-- Constants ---------------------------------

  MAX_INPUT_LENGTH = 15


  #-- Constructor -------------------------------

  # Creates an empty calculator input.
  #
  constructor: ->
    @clear()


  #-- Public methods ----------------------------

  # Adds the given digit to the input.
  #
  # @param [Number|String] digit  the digit that should be added
  # @return [Input]               this instance for method chaining
  #
  addDigit: (digit) ->
    input = @input
    @input = input + digit if input.length <= MAX_INPUT_LENGTH
    this

  # Adds a decimal point to the input.  The decimal point is added if not
  # already done.
  #
  # @return [Input] this instance for method chaining
  #
  addPoint: ->
    input = @input
    input = '0' unless input
    @input = input + '.' if input.indexOf('.') < 0
    this

  # Clears the input and resets the negative flag.
  #
  # @return [Input] this instance for method chaining
  #
  clear: ->
    @input = ''
    @negative = false
    this

  # Deletes the last character from input.
  #
  # @return [Input] this instance for method chaining
  #
  deleteLastChar: ->
    input = @input
    n = input.length
    @input = input.substring(0, n - 1) if n > 0
    this

  # Sets the input to the given number.
  #
  # @param [Number] number  the given number
  # @return [Input]         this instance for method chaining
  #
  setNumber: (number) ->
    if number is 0
      @input = ''
      @negative = false
    else
      negative = false
      if number < 0
        negative = true
        number *= -1
      @input = String(number)
      @negative = negative
    this

  # Toggles the negative flag.  If the input is empty the flag is unchanged.
  #
  # @return [Boolean] the new state of the negative flag
  #
  toggleNegative: ->
    @negative = not @negative unless @input is ''

  # Converts the input to a number.
  #
  # @return [Number]  the numeric representation of the input
  #
  toNumber: ->
    input = @input
    input = 0 if input is ''
    value = parseFloat input
    value *= -1 if @negative
    value

