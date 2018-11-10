# Static site for OpenDevStack

This project contains the files to generate the OpenDevStack website.
The web site uses the [jekyll](https://jekyllrb.com) static site generator.

To make it more usable on Windows, a gradle build script is avaialable.

To build and serve the web site, type : `gradlew jekyllServe`.
You can then access the web site at http://localhost:4000 .


## Layouts

Currently, we support the following layouts

* index
* documentation


### The documentation layout

For any page intended as documentation, specify the documentation layout in the front matter:

```
---
layout: documentation
---
```

This will automatically create a table of contents on the left.
It takes header levels 2 to 4 into account.


## Blog Posts

## Author Bio

## Events
