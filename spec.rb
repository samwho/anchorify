def tab width = 4
  '&nbsp;' * width
end

describe 'Anchorify' do
  it 'parses headings and gives them slugs' do
    to_parse = "<h1>Hello, world</h1>"
    output   = `./anchorify "#{to_parse}"`
    output.should == '<h1 id="hello,-world">Hello, world</h1>'
  end

  it 'does not overwrite existing header ids' do
    to_parse = "<h1 id='existing-id'>Hello, world</h1>"
    output   = `./anchorify "#{to_parse}"`
    output.should == "<h1 id='existing-id'>Hello, world</h1>"
  end

  it 'parses all levels of header' do
    (1..6).each do |level|
      to_parse = "<h#{level} id='existing-id'>Hello, world</h#{level}>"
      output   = `./anchorify "#{to_parse}"`
      output.should == "<h#{level} id='existing-id'>Hello, world</h#{level}>"
    end
  end

  it 'parses mixed header levels' do
    to_parse = %(
      <h1>Level 1</h1>
      <h2>Level 2</h2>
      <h3>Level 3</h3>
      <h4>Level 4</h4>
      <h5>Level 5</h5>
      <h6>Level 6</h6>
    )

    to_compare = %(
      <h1 id="level-1">Level 1</h1>
      <h2 id="level-2">Level 2</h2>
      <h3 id="level-3">Level 3</h3>
      <h4 id="level-4">Level 4</h4>
      <h5 id="level-5">Level 5</h5>
      <h6 id="level-6">Level 6</h6>
    )

    output = `./anchorify "#{to_parse}"`
    output.should == to_compare
  end

  it 'generates a table of contents' do
    # The parse and compare strings are aligned far left in this spec because
    # anchorify doesn't match the indentation level present in the parse
    # string. It just creates a table of contents in the far left.
    to_parse = %(
<toc>

<h1>Hello, world</h1>
    )

    to_compare = %(
<toc>
<a href="#hello,-world">Hello, world</a><br />
</toc>

<h1 id="hello,-world">Hello, world</h1>
    )
    output   = `./anchorify "#{to_parse}"`
    output.should == to_compare
  end

  it 'overwrites an existing table of contents if it finds one' do
    # The parse and compare strings are aligned far left in this spec because
    # anchorify doesn't match the indentation level present in the parse
    # string. It just creates a table of contents in the far left.
    to_parse = %(
<toc>
<a href="#hello,-james">Hello, james</a><br />
</toc>

<h1>Hello, world</h1>
    )

    to_compare = %(
<toc>
<a href="#hello,-world">Hello, world</a><br />
</toc>

<h1 id="hello,-world">Hello, world</h1>
    )
    output   = `./anchorify "#{to_parse}"`
    output.should == to_compare
  end

  it 'generates nested table of contents for multiple h levels' do
    to_parse = %(
<toc>

<h1>Level 1</h1>
<h2>Second level</h2>
<h2>Another second level</h2>
<h1>First</h1>
<h3>Third</h3>
<h4>Fourth</h4>
<h5>Fifth</h5>
<h6>Sixth</h6>
    )

    to_compare = %(
<toc>
#{tab * 0}<a href="#level-1">Level 1</a><br />
#{tab * 1}<a href="#second-level">Second level</a><br />
#{tab * 1}<a href="#another-second-level">Another second level</a><br />
#{tab * 0}<a href="#first">First</a><br />
#{tab * 2}<a href="#third">Third</a><br />
#{tab * 3}<a href="#fourth">Fourth</a><br />
#{tab * 4}<a href="#fifth">Fifth</a><br />
#{tab * 5}<a href="#sixth">Sixth</a><br />
</toc>

<h1 id="level-1">Level 1</h1>
<h2 id="second-level">Second level</h2>
<h2 id="another-second-level">Another second level</h2>
<h1 id="first">First</h1>
<h3 id="third">Third</h3>
<h4 id="fourth">Fourth</h4>
<h5 id="fifth">Fifth</h5>
<h6 id="sixth">Sixth</h6>
    )

    output   = `./anchorify "#{to_parse}"`
    output.should == to_compare

  end

  it 'uses already existing slugs in the table of contents if it finds any' do
    to_parse = %(
<toc>

<h1 id=\\"custom-slug\\">Level 1</h1>
<h2>Second level</h2>
<h2>Another second level</h2>
<h1>First</h1>
<h3>Third</h3>
<h4>Fourth</h4>
<h5>Fifth</h5>
<h6>Sixth</h6>
    )

    to_compare = %(
<toc>
#{tab * 0}<a href="#custom-slug">Level 1</a><br />
#{tab * 1}<a href="#second-level">Second level</a><br />
#{tab * 1}<a href="#another-second-level">Another second level</a><br />
#{tab * 0}<a href="#first">First</a><br />
#{tab * 2}<a href="#third">Third</a><br />
#{tab * 3}<a href="#fourth">Fourth</a><br />
#{tab * 4}<a href="#fifth">Fifth</a><br />
#{tab * 5}<a href="#sixth">Sixth</a><br />
</toc>

<h1 id="custom-slug">Level 1</h1>
<h2 id="second-level">Second level</h2>
<h2 id="another-second-level">Another second level</h2>
<h1 id="first">First</h1>
<h3 id="third">Third</h3>
<h4 id="fourth">Fourth</h4>
<h5 id="fifth">Fifth</h5>
<h6 id="sixth">Sixth</h6>
    )

    output   = `./anchorify "#{to_parse}"`
    output.should == to_compare
  end
end
