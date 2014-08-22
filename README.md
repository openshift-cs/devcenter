# OpenShift Online Developer Center
This repo contains AsciiDoc versions of the OpenShift Online Developer Center.

## Building the Manuals
The manuals themselves are .adoc files written in [AsciiDoc](http://asciidoc.org/), so they are easily human-readable. However, they are intended to be published in various formats, notably HTML.

### Building Locally w/Awestruct
Awestruct is a framework for creating static HTML sites, inspired by the [Jekyll](http://github.com/mojombo/jekyll) utility in the same genre. It requires at least Ruby 1.9.3.

First, install the awestruct and bundler gems and resolve any dependencies.
```
$ gem install awestruct bundler
```

### Local Live Preview with rake

To get started using Rake, within the /lib folder of this project, run:
```
$ rake setup
```
To generate the files, regenerate pages on changes, and starts a server to preview the site in your browser at http://localhost:4242, run:
```
$ rake
```

This is a shortcut for rake preview.

If you need to clear out the generated site from a previous run (recommended), simply run
```
$ rake clean preview
```

Content on the live site will look exactly as it does in your development environment. Please verify all content changes before submitting a pull request.


## Creating New Documents ##
At a minimum, the first several lines of a new .adoc document must follow this pattern:

    ---
    layout: base <1>
    category: 03_Languages <2>
    breadcrumb: Languages <3>
    parent_url: <4>
    nav_title: JBossAS/Wildfly <5>
    nav_priority: 2 <6>
    ---
    = JBossAS Overview <7>
    :source-highlighter: coderay <8>
    :icons: <9>

    Start writing your content here.

    <1> .haml layout used by page (defined in _layouts - in general use base)
    <2> Used for left-nav categorization/display. Number is priority level, String is leftnav display string
    <3> Used for breadcrumbs - should be same as category without numbers or underscore
    <4> Used for breadcrumbs - url of parent
    <5> Used in leftnav - Link text for this specific page
    <6> Used in leftnav - sort order for the page in this specific category
    <7> Title of page (only set once)
    <8> include this line if you need source code colorization (using coderay)
    <9> Allows the use of icons for admonition blocks (e.g. TIP, IMPORTANT, etc.)

For the rest of the document, make sure that you are following proper [AsciiDoc syntax](http://asciidoctor.org/docs/asciidoc-writers-guide/) and preview your document before submitting a pull request. There's no magic in how the documentation is built, so if it doesn't look right in your sandbox, it won't look right on the documentation site.
