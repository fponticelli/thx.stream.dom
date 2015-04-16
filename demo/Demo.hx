import js.Browser;
import js.html.CanvasElement;
import js.html.DOMElement as Element;
import js.html.DivElement;
import js.html.PreElement;
import js.html.ButtonElement;
import js.html.InputElement;

using thx.stream.dom.Dom;

class Demo {
  public static function mouseMove(demo : Demo) {
    var el     = demo.panel('mouse move', "container
  .streamMouseMove()
  .pluck('x: ${_.clientX}, y: ${_.clientY}')
  .subscribe(output.subscribeText());"),
        output = demo.output(el);
    demo.container
      .streamMouseMove()
      .pluck('x: ${_.clientX}, y: ${_.clientY}')
      .subscribe(output.subscribeText());
  }

  public static function click(demo : Demo) {
    var el     = demo.panel('click count', "click
  .streamClick()
  .reduce(0, function(acc, _) return acc + 1)
  .pluck('clicks: $_')
  .subscribe(output.subscribeText());"),
        click  = demo.button('click', el),
        output = demo.output(el);
    click
      .streamClick()
      .reduce(0, function(acc, _) return acc + 1)
      .pluck('clicks: $_')
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
  .pluck('count: $_')
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
      .pluck('count: $_')
      .subscribe(output.subscribeText());
  }

  public static function replicate(demo : Demo) {
    var el     = demo.panel('replicate text', "input
  .streamInput()
  .pluck(_.toUpperCase())
  .subscribe(output.subscribeText());"),
        input  = demo.input('type text', el),
        output = demo.output(el);
    input
      .streamInput()
      .pluck(_.toUpperCase())
      .subscribe(output.subscribeText());
  }

  public static function draw(demo : Demo) {
    var el  = demo.panel('draw canvas', 'canvas.streamMouseMove()
  .map(function(e) {
    var bb = canvas.getBoundingClientRect();
    return { x : e.clientX - bb.left, y : e.clientY - bb.top };
  })
  .window(2)
  .pair(canvas
    .streamMouseDown()
    .toTrue()
    .merge(canvas.streamMouseUp().toFalse()))
  .filterPluck(_._1)
  .pluck(_._0)
  .subscribe(function(e) {
    ctx.beginPath();
    ctx.moveTo(e[0].x, e[0].y);
    ctx.lineTo(e[1].x, e[1].y);
    ctx.stroke();
  });'),
        canvas = demo.canvas(470, 240, el),
        ctx    = canvas.getContext2d();

    ctx.lineWidth = 4;
    ctx.strokeStyle = "#345";
    ctx.lineCap = "round";

    canvas.streamMouseMove()
      .map(function(e) {
        var bb = canvas.getBoundingClientRect();
        return { x : e.clientX - bb.left, y : e.clientY - bb.top };
      })
      .window(2)
      .pair(canvas
        .streamMouseDown()
        .toTrue()
        .merge(canvas.streamMouseUp().toFalse()))
      .filterPluck(_._1)
      .pluck(_._0)
      .subscribe(function(e) {
        ctx.beginPath();
        ctx.moveTo(e[0].x, e[0].y);
        ctx.lineTo(e[1].x, e[1].y);
        ctx.stroke();
      });
  }

  public static function main() {
    var demo = new Demo(Browser.document.getElementById('container'));

    mouseMove(demo);
    click(demo);
    plusMinus(demo);
    replicate(demo);
    draw(demo);
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
    el.textContent = content;
    append(el, container);
    return el;
  }

  public function button(label : String, ?container : Element) : ButtonElement {
    var el = Browser.document.createButtonElement();
    el.textContent = label;
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

  public function canvas(width : Int, height : Int, ?container : Element) : CanvasElement {
    var el = Browser.document.createCanvasElement();
    el.width = width;
    el.height = height;
    append(el, container);
    return el;
  }

  function append(el : Element, container : Element) {
    if(null == container)
      container = this.container;
    container.appendChild(el);
  }
}