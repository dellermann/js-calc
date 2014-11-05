#
# input.coffee
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

