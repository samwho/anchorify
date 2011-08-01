# Anchorify

Anchorify is a simple script written in Ruby that parses an HTML
document to produce anchored headings and an optional table of contents.

The script parses the input HTML document and searches for <hn> tags ("n" being a number from 1 to 6). It replaces these tags with an "anchored" version, like so:

  <h1>Hello, everybody!<h1> # This gets changed to the following line
  <h1 id="hello,-everybody!">Hello, everybody!</h1>

And the table of contents that goes with that would look like this:

  <a href="#hello,-everybody!">Hello, everybody!</a>

# Nested headings

For each new header level (<h1>, <h2> etc.), a new indented level is used
in the table of contents. For example:

  <h1>Foo</h1>
  <h2>Bar</h2>
  <h2>Baz</h2>
  <h3>Chunky Bacon</h3>

Would generate a table of contents that looks like this:

  Foo
      Bar
      Baz
          Chunky Bacon

# Usage

Using the script is easy. The only prerequisite is having ruby installed
on your system, then you just execute:

  anchorify example.html

Where example.html is an HTML document. The output is printed to the
screen so if you want to save to another file you would do the following:

  anchorify example.html >> anchorified.html

# Adding a table of contents

Adding a table of contents to your document is easy, simply put the pseudo
tag <toc> somewhere in your HTML document and the script will replace that
with the table of contents in the resulting HTML.
