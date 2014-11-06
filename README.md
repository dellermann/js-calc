# js-calc

js-calc is a client-side calculator developed in JavaScript and CSS that is
compatible with [Bootstrap][] and [jQuery][].

## Usage

In order to use js-calc add a HTML container element, e. g.

```html
<div class="calculator"></div>
```

Add `<script></script>` tags to load jQuery and js-calc (optionally use the
minified versions):

```html
<script src="jquery.min.js"></script>
<script src="js-calc.min.js"></script>
```

Then call the following code in JavaScript:

```javascript
$(".calculator").jscalc();
```

### Options

You can specify the following options when calling `jscalc()`:

* `point` (String). Specifies the locale-dependent character for the
  decimal point (default is ".").

### Examples

```javascript
$(".calculator").jscalc();      // use default options
$(".calculator").jscalc({
    point: ","
});                             // use German notation
```

## Build <a name="Build"></a>

To build js-calc perform the following steps:

1.  Prepare the `npm` environment using

    ```shell
    $ npm install
    ```

2.  Then execute

    ```shell
    $ grunt
    ```

3.  Afterwards, you find the built js-calc files in ``target/build`` as well
    as a documentation in ``target/docs``.

## Demo

To build and view a demo perform the following steps:

1.  Install needed `npm` modules using

    ```shell
    $ npm install
    ```

2.  Build the demo page using

    ```shell
    $ grunt demo
    ```

3.  View `demo.html` in folder `target/demo` using your favorite browser.

## Customization

If you wish to customize the calculator, feel free to change the LESS variables
in ``less/variables.less`` and re-build the software as described under 
[Build](#Build).

## License

This piece of software was released under the [MIT License][MIT].

[Bootstrap]: http://getbootstrap.com
[jQuery]: http://jquery.com
[MIT]: http://opensource.org/licenses/MIT

