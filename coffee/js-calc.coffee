###

  js-calc.coffee

  Copyright (c) 2014-2016, Daniel Ellermann

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
  THE SOFTWARE.

###


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


  #-- Fields ------------------------------------

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
    @enabled = false

    @_renderTemplate()


  #-- Public methods ----------------------------

  # Disables the calculator.  If disabled all key events are not handled.
  #
  # @since 0.9
  #
  disable: -> @enabled = false

  # Enables the calculator.  If enabled all key events are handled.
  #
  # @since 0.9
  #
  enable: -> @enabled = true


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
    @_operate() unless opStack.isEmpty() or @_getOperatorPriority(op) < 1
    @_calcBaseOp if mult then '*' else '/'

  # Performs either an addition or subtraction.
  #
  # @param [Boolean] plus `true` to add; `false` to subtract
  # @private
  #
  _calcPlusMinus: (plus) ->
    @_operate() unless @opStack.isEmpty()
    @_calcBaseOp if plus then '+' else '-'

  # Calculates the power of register X2 and X1.
  #
  # @private
  #
  _calcPower: ->
    opStack = @opStack
    op = opStack.peek()
    @_operate() unless opStack.isEmpty() or @_getOperatorPriority(op) < 2
    @_calcBaseOp '^'

  # Calculates the result of a binary operation.  The method processes all
  # operators stored on the operator stack and displays the result.
  #
  # @private
  #
  _calcResult: ->
    @_operate()
    @input.clear()

  # Calculates all operations which are currently on the stack.
  #
  # @private
  #
  _operate: ->
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
        when '^' then res = x2 ** x1
        when 'root' then res = Math.pow(x2, 1 / x1)
      stack.push res

    @_displayOutput stack.peek()

  # Calculates the n-th root of register X2, where n = register X1.
  #
  # @private
  #
  _calcRoot: ->
    opStack = @opStack
    op = opStack.peek()
    @_operate() unless opStack.isEmpty() or @_getOperatorPriority(op) < 2
    @_calcBaseOp 'root'

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

  # Clears the input register.
  #
  # @private
  #
  _clearInput: ->
    @input.clear()
    @_displayInput()

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
      # bugfix #2
      value = String(parseFloat(value.toPrecision Input.MAX_INPUT_LENGTH))
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

  # Gets the priority of the given binary operator.
  #
  # @param [String] op  the given binary operator
  # @return [Number]    the priority
  # @private
  #
  _getOperatorPriority: (op) ->
    switch op
      when '+', '-' then return 0
      when '*', '/' then return 1
      when '^', 'root' then return 2
      else return `undefined`

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
        when '^'
          @_calcPower()
        when 'root'
          @_calcRoot()
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

  # Called if a key has been pressed down.
  #
  # @param [Event] event  any event data
  # @return [Boolean]     a value indicating whether event bubbling should occur
  # @private
  #
  _onKeyDown: (event) ->
    return true unless @enabled

    code = event.which
    if code is 46
      @$element.find(".jscalc-key[data-code='AC']")
        .addClass('active')
        .click()
      false

    true

  # Called if a key has been pressed.
  #
  # @param [Event] event  any event data
  # @return [Boolean]     a value indicating whether event bubbling should occur
  # @private
  #
  _onKeyPress: (event) ->
    return true unless @enabled

    keyCode = null
    code = String.fromCharCode event.which
    switch code
      when '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '-', '*', '/', '%', '^'
        keyCode = code
      when '.', @options.point
        keyCode = '.'
      when '#'
        keyCode = '+/-'
      when '\r', '='
        keyCode = '='
      when '\b'
        keyCode = 'DEL'
      when 'c', 'C'
        keyCode = 'CE'
      when '²'
        keyCode = 'x^2'
      when '\\'
        keyCode = '1/x'
      when 'r', 'R'
        keyCode = 'MR'
      when 's', 'S'
        keyCode = 'MS'

    if keyCode
      @$element.find(".jscalc-key[data-code='#{keyCode}']")
        .addClass('active')
        .click()
      event.stopPropagation()
      event.preventDefault()

    true

  # Called if the user releases a key.
  #
  # @return [Boolean] always `true` to allow event bubbling
  # @private
  #
  _onKeyUp: ->
    return true unless @enabled

    @$element.find(".jscalc-key")
      .removeClass('active')
    true

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
    $(window).on('keypress', (event) => @_onKeyPress event)
      .on('keydown', (event) => @_onKeyDown event)
      .on('keyup', (event) => @_onKeyUp())
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
    data[option]() if typeof option is 'string'

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
