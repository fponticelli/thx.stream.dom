import js.Browser;
import js.html.*;

using thx.stream.dom.Dom;

class Demo {
  public static function mouseMove(demo : Demo) {
    var el     = demo.panel('mouse move', "container
  .streamMouseEvent('mousemove')
  .mapValue(function(e) return 'x: ${e.clientX}, y: ${e.clientY}')
  .subscribe(output.subscribeText());"),
        output = demo.output(el);
    demo.container
      .streamMouseEvent('mousemove')
      .mapValue(function(e) return 'x: ${e.clientX}, y: ${e.clientY}')
      .subscribe(output.subscribeText());
  }

  public static function click(demo : Demo) {
    var el     = demo.panel('click count', "click
  .streamClick()
  .reduce(0, function(acc, _) return acc + 1)
  .mapValue(function(count) return 'clicks: $count')
  .subscribe(output.subscribeText());"),
        click  = demo.button('click', el),
        output = demo.output(el);
    click
      .streamClick()
      .reduce(0, function(acc, _) return acc + 1)
      .mapValue(function(count) return 'clicks: $count')
      .subscribe(output.subscribeText());
  }

  public static function plusMinus(demo : Demo) {
    var el     = demo.panel('plus & minus', "plus
  .streamClick()
  .toValue(1)
  .merge(
    minus
      .streamClick()
      .toValue(-1)
  )
  .reduce(0, function(acc, v) return acc + v)
  .mapValue(function(count) return 'count: $count')
  .subscribe(output.subscribeText());"),
        plus   = demo.button('+', el),
        minus  = demo.button('-', el),
        output = demo.output(el);
    plus
      .streamClick()
      .toValue(1)
      .merge(
        minus
          .streamClick()
          .toValue(-1)
      )
      .reduce(0, function(acc, v) return acc + v)
      .mapValue(function(count) return 'count: $count')
      .subscribe(output.subscribeText());
  }

  public static function replicate(demo : Demo) {
    var el     = demo.panel('replicate text', "input
  .streamInput()
  .mapValue(function(s) return s.toUpperCase())
  .subscribe(output.subscribeText());"),
        input  = demo.input('type text', el),
        output = demo.output(el);
    input
      .streamInput()
      .mapValue(function(s) return s.toUpperCase())
      .subscribe(output.subscribeText());
  }

  public static function main() {
    var demo = new Demo(Browser.document.getElementById('container'));

    mouseMove(demo);
    click(demo);
    plusMinus(demo);
    replicate(demo);
  }

  public var container(default, null) : Element;
  public function new(container : Element) {
    this.container = container;
  }

  public function panel(label : String, ?code : String, ?container : Element) : DivElement {
    var panel   = div("panel", container),
        h2      = h2(label, panel);
    if(null != code)
      pre(code, panel);
    return div(panel);
  }

  public function h2(text : String, ?container : Element) : Element {
    var el = Browser.document.createElement('h2');
    el.innerHTML = text;
    append(el, container);
    return el;
  }

  public function output(?container : Element) : DivElement {
    return div('output', container);
  }

  public function div(?className : String, ?container : Element) : DivElement {
    var el = Browser.document.createDivElement();
    if(null != className)
      el.className = className;
    append(el, container);
    return el;
  }

  public function pre(content : String, ?container : Element) : PreElement {
    var el = Browser.document.createPreElement();
    el.innerText = content;
    append(el, container);
    return el;
  }

  public function button(label : String, ?container : Element) : ButtonElement {
    var el = Browser.document.createButtonElement();
    el.innerText = label;
    append(el, container);
    return el;
  }

  public function input(?placeholder : String, ?container : Element) : InputElement {
    var el = Browser.document.createInputElement();
    if(null != placeholder)
      el.placeholder = placeholder;
    append(el, container);
    return el;
  }

  function append(el : Element, container : Element) {
    if(null == container)
      container = this.container;
    container.appendChild(el);
  }
}