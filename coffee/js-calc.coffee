#
# js-calc.coffee
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


# @nodoc
$ = jQuery


# Class `Calculator` represents the client-side calculator.
#
# @author   Daniel Ellermann
# @version  0.9
# @since    0.9
#
class Calculator

  #-- Private variables -------------------------

  $ = jQuery


  #-- Constructor -------------------------------
  
  constructor: (element) ->
    @$element = $el = $(element)
    @input = new Input()
    @point = ','
    @pointEntered = false
    @minus = false
    @stack = new Stack()

    @_renderTemplate()


  #-- Non-public methods ------------------------

  _allClear: ->
    @stack.clear()
    @input.clear()
    @_updateDisplay()

  _calcSquare: ->
    stack = @stack
    x = stack.pop()
    x *= x
    stack.push x
    @_output x

  # Deletes the last character from input.
  #
  # @private
  #
  _deleteLastChar: ->
    @input.deleteLastChar()
    @_updateDisplay()

  # Enters the given digit.
  #
  # @param [Number] digit the digit that has been entered
  # @private
  #
  _enterDigit: (digit) ->
    @input.addDigit digit
    @_updateDisplay()

  # Enters a decimal point if not already done.
  #
  # @private
  #
  _enterPoint: ->
    @input.addPoint()
    @_updateDisplay()

  _onClickKey: (event) ->
    $target = $(event.currentTarget)

    code = $target.data 'code'
    switch code
      when 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
        @_enterDigit code
      when '.'
        @_enterPoint()
      when '+/-'
        @_toggleSign()
      when 'DEL'
        @_deleteLastChar()
      when 'AC'
        @_allClear()
      when 'x^2'
        @_calcSquare()

  _output: (value) ->
    @minus = value < 0
    output = String(Math.abs(value)).replace /\./, @point
    @_updateDisplay output

  # Renders the Handlebars template that displays the calculator.
  #
  # @private
  #
  _renderTemplate: ->
    html = Handlebars.templates['js-calc']
      point: @point
    @$element.empty()
      .html(html)
      .on('click', '.key', (event) => @_onClickKey event)

  # Toggles the sign (plus/minus) of the input.
  #
  # @private
  #
  _toggleSign: ->
    @input.toggleNegative()
    @_updateDisplay()

  _updateDisplay: ->
    input += @point unless @pointEntered
    @$element.find('.display')
      .find('output')
        .text(input)
      .end()
      .find('.sign')
        .text(if @minus then '—' else '')
    @_updateInputRegister input

  _updateInputRegister: (input) ->
    value = parseFloat(input.replace @point, '.')
    value *= -1 if @minus
    @stack.setTop value


Plugin = (option) ->
  args = arguments
  @each ->
    $this = $(this)
    data = $this.data 'bs.jscalc'

    unless data
      $this.data 'bs.jscalc', (data = new Calculator(this, args[0]))

# @nodoc
old = $.fn.jscalc

# @nodoc
$.fn.jscalc = Plugin
# @nodoc
$.fn.jscalc.Constructor = Calculator

# @nodoc
$.fn.jscalc.noConflict = ->
  $.fn.jscalc = old
  this

