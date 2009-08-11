h1. Narf

h2. Introduction

Narf Ain't a Real Framework. Consider it more of a web _tool,_ for quickly creating a web interface to something. _Narf is not for making websites._ It's more for a web front-end to a larger program.

h2. How does it work?

Narf is extremely lightweight. You can build a complete Narf server in only a few lines of code. Here's an example:

<pre><code>
Narf.new do
  expose :class=>MyClass, :as=>"/"
end
</code></pre>

Narf works by exposing things: classes, directories, or templates. When you expose something, you're routing all requests for URLs under that path to that object.

In the above example, we're mapping requests like this:

|*URL* | *Ruby equivalent*|
|http://localhost:3000/foo | <code>MyClass.new.foo</code>|
|http://localhost:3000/foo/bar | <code>MyClass.new.foo('bar')</code>|
|http://localhost:3000/foo?a=3 | <code>MyClass.new.foo({'a'=>'3'})</code>|

Results from method calls are always rendered back as JSON: _classes don't render templates, templates render templates._ Templates talk to classes through AJAX.

Exposing templates is easy:

<pre><code>
Narf.new do
  expose :class=>MyClass
  expose :templates=>"my_app/views", :as=>"/"
end
</code></pre>

Note that we've gotten rid of the ":as" on the class; we can now access it by the default of "myclass". The template directory we're exposing should be a directory full of Haml templates (other kinds in the future, Haml only for now):

|*URL* | *Template*|
|http://localhost:3000/foo | /my_app/views/foo.haml |
|http://localhost:3000/foo/bar | /my_app/views/bar/foo.haml |
|http://localhost:3000/foo?a=3 | /my_app/views/bar/foo.haml |

That last one will render with a local variable 'a' set to '3'.

Your templates will probably require static files, which are just as easy to expose:

<pre><code>
Narf.new do
  expose :class=>MyClass
  expose :templates=>"my_app/views", :as=>"/"
  expose :directory=>"resources/dojo-1.3.2", :as=>"/dojo"
end
</code></pre>

These work the same way as templates, but they're not run through Haml first, they're just sent straight to the client.

Obviously you can expose more than one of each type. When you've finished making the server, just start it up:

<pre><code>
narf = Narf.new(:port=>5000) do
  . . .
end
narf.start
</code></pre>

That's all there is to it!

h2. What can I do with it?

Narf was designed to embed into larger programs. It keeps your web API very simple (just a normal class, returning normal objects) and keeps the fancy web templates and Javascript well separated from it. With Narf, you can easily add a web admin interface to your program without having to reorganize very much.

Narf is emphatically _not_ an MVC framework: there's no model layer at all, and the views and controllers have nothing to do with one another. If you want a batteries-included MVC framework, there are dozens; if you want something tiny that will get out of your way, Narf might be for you!

h2. What is Narf built on?

Narf was built using Rack and Haml, two excellent packages which you should be using if you're not.
