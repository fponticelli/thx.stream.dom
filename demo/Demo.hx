import js.Browser;
import js.html.CanvasElement;
import js.html.DOMElement as Element;
import js.html.DivElement;
import js.html.PreElement;
import js.html.ButtonElement;
import js.html.InputElement;

using thx.stream.dom.Dom;
using thx.Functions;
using thx.stream.StreamExtensions;

class Demo {
  public static function mouseMove(demo : Demo) {
    var el     = demo.panel('mouse move', "container
  .streamMouseMove()
  .map.fn('x: ${_.clientX}, y: ${_.clientY}')
  .next(output.receive()).run();"),
        output = demo.output(el);
    demo.container
      .streamMouseMove()
      .map.fn('x: ${_.clientX}, y: ${_.clientY}')
      .next(output.receive()).run();
  }

  public static function click(demo : Demo) {
    var el     = demo.panel('click count', "click
  .streamClick()
  .count()
  .map.fn('clicks: $_')
  .next(output.receive()).run();"),
        click  = demo.button('click', el),
        output = demo.output(el);
    click
      .streamClick()
      .count()
      .map.fn('clicks: $_')
      .next(output.receive()).run();
  }

  public static function plusMinus(demo : Demo) {
    var el     = demo.panel('plus & minus', "plus
  .streamClick().toValue(1)
  .merge(
    minus.streamClick().toValue(-1)
  )
  .reduce(function(acc, v) return acc + v, 0)
  .map.fn('count: $_')
  .next(output.receive()).run();"),
        plus   = demo.button('+', el),
        minus  = demo.button('-', el),
        output = demo.output(el);
    plus
      .streamClick().toValue(1)
      .merge(
        minus.streamClick().toValue(-1)
      )
      .reduce(function(acc, v) return acc + v, 0)
      .map.fn('count: $_')
      .next(output.receive()).run();
  }

  public static function replicate(demo : Demo) {
    var el     = demo.panel('replicate text', "input
  .streamInput()
  .map.fn(_.toUpperCase())
  .next(output.receive()).run();"),
        input  = demo.input('type text', el),
        output = demo.output(el);
    input
      .streamInput()
      .map.fn(_.toUpperCase())
      .next(output.receive()).run();
  }

  public static function draw(demo : Demo) {
    var el  = demo.panel('draw canvas', 'canvas.streamMouseMove()
  .map(function(e) {
    var bb = canvas.getBoundingClientRect();
    return { x : e.clientX - bb.left, y : e.clientY - bb.top };
  })
  .slidingWindow(2, 2)
  .pair(
    canvas
      .streamMouseDown().toTrue()
      .merge(canvas.streamMouseUp().toFalse())
  )
  .filter.fn(_._1)
  .left()
  .next(function(e) {
    ctx.beginPath();
    ctx.moveTo(e[0].x, e[0].y);
    ctx.lineTo(e[1].x, e[1].y);
    ctx.stroke();
  }).run();'),
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
      .slidingWindow(2, 2)
      .pair(
        canvas
          .streamMouseDown().toTrue()
          .merge(canvas.streamMouseUp().toFalse())
      )
      .filter.fn(_._1)
      .left()
      .next(function(e) {
        ctx.beginPath();
        ctx.moveTo(e[0].x, e[0].y);
        ctx.lineTo(e[1].x, e[1].y);
        ctx.stroke();
      }).run();
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
