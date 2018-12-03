# Static site for OpenDevStack

This project contains the files to generate the OpenDevStack website.
The web site uses the [jekyll](https://jekyllrb.com) static site generator.

You currently need to have a full Ruby installation at your hands.
Serve the site using `bundle exec jekyll s`.

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

This follows the Jekyll conventions. Place your blog posts into the `_posts` directory.
It would be possible to create _drafts_ by placing a post (without a date) into the [`_drafts` folder](https://jekyllrb.com/docs/posts/).
But as we require PRs, simply put your proposal into the `_posts` directory.

Blog Posts have a bit of front matter.
We currently support the `author` keyword.

    author: richard.attermeyer

The author name, should match the one in your author bio.

## Author Bio

You can (but you need not) add an author bio into the `_authors` folder.
The name of the file should match the auther name you are using in your posts, e.g. `richard.attermeyer`.
The file again consits of some meta data in the front-matter and the content.
