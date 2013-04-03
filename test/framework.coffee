$ = require "jquery"
{mvc, template} = require "../src/framework"

describe "template", ->

  it "should register the `safe` helper", ->

    tmpl = template.compile "<div>{{safe content}}</div>"
    content = "<a href='#'>link</a>"
    res = tmpl {content}
    res.should.equal "<div><a href='#'>link</a></div>"
