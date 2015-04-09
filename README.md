# middleman-org


## What and Why

`middleman-org` is an extention for [middleman](https://middlemanapp.com) to generate static pages from [org file](http://orgmode.org).
It is highly inspired by the offical blog extention [middleman-blog](https://github.com/middleman/middleman-blog), but it is not another blogging extention.

## Advantages of using `middleman-org`

### Linking

Org mode is powerful as a whole system. You expect connections between files. Or being able to reference some kind of resource files (e.g. input data, image etc.) within org. `middleman-org` preserve the complete structure of your system, so that you will have the whole set exported with no breaking links.

### No more `front mater`

Is it just me or... I found the `yaml front mater` is just annoying in such scenario. You don't want to pollute your org files with it, do you? `middleman-org` uses native org-mode in buffer settings as metadata of your article.
So instead of

```yaml
---
title: my polluted article
date: 2015-04-09
tags: polluted, lame
---
```

You can use

```org
#+TITLE: my awesome article
#+DATE: <2015-04-09 Thu>
#+KEYWORDS: awesome nice
```

### Selective Publish

This is implemented by [org-ruby](https://github.com/bdewey/org-ruby), the rendering engine we use in `middleman-org`. Just simply apply [export settings](http://orgmode.org/manual/Export-settings.html) natively in your org file, sections with exclusion tags will not be published.

## Installation

Add `middleman-org` to your `Gemfile` and run `bundle install`.
## Configuration

And activate it in `config.rb`.

```ruby
activate :org
```

With default settings, create a folder `org` inside your `source` folder and dump all your org files into it.
If you use git to manage your org files, it is highly recommaned to add your org repository as a submodule.

option | default | meaning
---|---|---
`layout` | 'layout' | article specific layout
`root` | 'org' | root folder for org files (relative to `source` folder)
`prefix` | nil | prefix on root and destination path
