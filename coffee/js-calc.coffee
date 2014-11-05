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


  #-- Instance variables ------------------------
  
  DEFAULT_OPTIONS =
    point: '.'


  #-- Constructor -------------------------------
  
  # Creates a new calculator within the given element.
  #
  # @param [Element] element  the given container element
  # @param [Object] options   any options that overwrite the default options
  #
  constructor: (element, options = {}) ->
    @$element = $el = $(element)
    @options = $.extend {}, DEFAULT_OPTIONS, options

    @input = new Input()
    @stack = new Stack()
    @opStack = new Stack()
    @error = false
    @memory = 0

    @_renderTemplate()


  #-- Non-public methods ------------------------

  # Clear the input and the stacks.
  #
  # @private
  #
  _allClear: ->
    @stack.clear()
    @opStack.clear()
    @input.clear()
    @error = false
    @_displayInput()

  # Calculates the given base operation (plus, minus, times, divided by).  The
  # method pushes the operator on the operator stack and duplicates the value
  # on top of the operand stack.  At last, it clears the input.
  #
  # @param [String] op  the given base operation
  # @private
  #
  _calcBaseOp: (op) ->
    @opStack.push op
    @stack.duplicate()
    @input.clear()
    return

  # Performs either a multiplication or division.
  #
  # @param [Boolean] mult `true` to multiply; `false` to divide
  # @private
  #
  _calcMultDiv: (mult) ->
    opStack = @opStack
    op = opStack.peek()
    @_calcResult() unless opStack.isEmpty() or op is '+' or op is '-'
    @_calcBaseOp if mult then '*' else '/'

  # Performs either an addition or subtraction.
  #
  # @param [Boolean] plus `true` to add; `false` to subtract
  # @private
  #
  _calcPlusMinus: (plus) ->
    @_calcResult() unless @opStack.isEmpty()
    @_calcBaseOp if plus then '+' else '-'

  # Calculates the result of a binary operation.  The method processes all
  # operators stored on the operator stack and displays the result.
  #
  # @private
  #
  _calcResult: ->
    stack = @stack
    opStack = @opStack
    until opStack.isEmpty()
      x1 = stack.pop()
      x2 = stack.pop()
      op = opStack.pop()
      switch op
        when '+' then res = x2 + x1
        when '-' then res = x2 - x1
        when '*' then res = x2 * x1
        when '/' then res = x2 / x1
      stack.push res

    @_displayOutput stack.peek()

  # Clears the input register.
  #
  # @private
  #
  _clearInput: ->
    @input.clear()
    @_displayInput()

  # Computes an unary operation using the given operator function.
  #
  # @param [Function] func  the given operator function
  # @private
  #
  _calcUnaryOp: (func) ->
    stack = @stack
    x1 = stack.pop()
    x1 = func x1
    stack.push x1
    @_displayOutput x1

  # Deletes the last character from input.
  #
  # @private
  #
  _deleteLastChar: ->
    @input.deleteLastChar()
    @_displayInput()

  # Displays the current input.
  #
  # @private
  #
  _displayInput: ->
    input = @input
    @stack.setTop input.toNumber()
    @_displayValue input.input, input.negative

  # Shows or hides the memory indicator in the display.
  #
  # @private
  #
  _displayMemory: ->
    @$element.find('.jscalc-display .jscalc-memory')
      .toggleClass('active', @memory isnt 0)

  # Displays the given numeric value.
  #
  # @param [Number] value the value that should be displayed
  # @private
  #
  _displayOutput: (value) ->
    negative = false
    unless @_isError value
      if value < 0
        negative = true
        value *= -1
      value = String(value)
    @_displayValue value, negative

  # Displays the given value with optional negative flag.
  #
  # @param [String] value     the value that should be displayed
  # @param [Boolean] negative `true` if the value is negative; `false` otherwise
  # @private
  #
  _displayValue: (value, negative) ->
    @error = error = @_isError value
    value = '0' if value is '' or error
    value += '.' if value.indexOf('.') < 0
    value = value.replace /\./, @options.point
    @$element.find('.jscalc-display')
      .find('output')
        .text(value)
      .end()
      .find('.jscalc-sign')
        .toggleClass('active', negative)
      .end()
      .find('.jscalc-error')
        .toggleClass('active', error)
    @_displayMemory()
    return

  # Enters the given digit.
  #
  # @param [Number] digit the digit that has been entered
  # @private
  #
  _enterDigit: (digit) ->
    @input.addDigit digit
    @_displayInput()

  # Enters a decimal point if not already done.
  #
  # @private
  #
  _enterPoint: ->
    @input.addPoint()
    @_displayInput()
  
  # Checks whether the given value represents a calculation error.
  #
  # @param [Number|NaN] value the value that should be checked
  # @return [Boolean]         `true` if the given value represents an error; `false` otherwise
  # @private
  #
  _isError: (value) ->
    isNaN(value) or not isFinite(value)

  # Clears the value in memory.
  #
  # @private
  #
  _memoryClear: ->
    @memory = 0
    @_displayMemory()

  # Adds register X1 to memory.
  #
  # @private
  #
  _memoryPlus: ->
    @memory += @stack.peek()
    @_displayMemory()

  # Replaces the current input by the value of memory.
  #
  # @private
  #
  _memoryRecall: ->
    @input.setNumber @memory
    @_displayInput()

  # Stores register X1 to memory.
  #
  # @private
  #
  _memorySet: ->
    @memory = @stack.peek()
    @_displayMemory()

  # Called if the user clicks a key on the calculator's keyboard.
  #
  # @param [Event] event  any event data
  # @return [Boolean]     always `false` to prevent event bubbling
  # @private
  #
  _onClickKey: (event) ->
    $target = $(event.currentTarget)

    code = $target.data 'code'
    if not @error or code is 'AC'
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
        when 'CE'
          @_clearInput()
        when '+'
          @_calcPlusMinus true
        when '-'
          @_calcPlusMinus false
        when '*'
          @_calcMultDiv true
        when '/'
          @_calcMultDiv false
        when '%'
          @_calcUnaryOp (x1) -> x1 / 100
        when 'x^2'
          @_calcUnaryOp (x1) -> x1 * x1
        when 'sqrt'
          @_calcUnaryOp (x1) -> Math.sqrt x1
        when '1/x'
          @_calcUnaryOp (x1) -> 1 / x1
        when '='
          @_calcResult()
        when 'MR'
          @_memoryRecall()
        when 'MS'
          @_memorySet()
        when 'M+'
          @_memoryPlus()
        when 'MC'
          @_memoryClear()

    false

  # Renders the Handlebars template that displays the calculator.
  #
  # @private
  #
  _renderTemplate: ->
    html = Handlebars.templates['js-calc']
      point: @options.point
    @$element.empty()
      .html(html)
      .on('click', '.jscalc-key', (event) => @_onClickKey event)
    @_displayInput()

  # Toggles the sign (plus/minus) of the input.
  #
  # @private
  #
  _toggleSign: ->
    @input.toggleNegative()
    @_displayInput()


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

