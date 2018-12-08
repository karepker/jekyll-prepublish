# `jekyll-prepublish`

`jekyll-prepublish` is a gem for running arbitrary validation against individual
posts and outputting errors based on their content or configuration.

## Quick start

### Installation

Add the following to your `Gemfile` in your Jekyll root directory.

```
gem 'jekyll-prepublish', :git => 'https://github.com/karepker/jekyll-prepublish.git'
```

Then run `bundler update`.

### Configuration

Add the following to your `_config.yml` in your Jekyll root directory.

```yaml
jekyll-prepublish:
  validators:
    HTML span blacklist:
      blacklisted_classes:
        - redact
        - remove
        - reword
    post tag whitelist:
      tag_whitelist:
        - blog
        - public
    internal link:
```

Read more about the configuration options [below](#configuration-options).

### Running

To run `jekyll-prepublish` against `jekyll_root/path/to/post.md`, run the
following command in your Jekyll root directory:

`$ bundler exec jekyll prepublish -p "jekyll_root/path/to/post.md"`

See [below](#version-control-hooks) for an example of how to integrate it into
your version control hooks.

## Usage

### Configuration options

By default `jekyll-prepublish` does not run any validation on given post.
Validators must be specified in the Jekyll configuration file. This is done with
the following syntax:

```yaml
jekyll-prepublish:
  validators:
    validator 1:
      <validator 1 specific options>
    validator 2:
      <validator 2 specific options>
```

Currently available validators are:

1. `HTML span`: Validates that a given post has no span classes on the blacklist
   given in the configuration.

   Options:
    * `blacklisted_classes`: Classes not allowed on `<span>` elements the HTML
      generated from the post body.

1. `internal link`: Validates that internal links pointed to by the post exist.

   No options.

1. `post tag`: Validates that all tags on the post are on a whitelist given in
   the configuration.

   Options:
    * `tag_whitelist`: Tags that are allowed on the post.

### Version control hooks

It is useful to integrate `jekyll-prepublish` into version control-based hooks
that run and check its output before code is submitted automatically.

For git, an example hook setup would be to put the following script in
`.git/hooks/pre-commit`:

```bash
#!/bin/bash

total_failed_validators=0

for pending_file in $(git diff --name-only --cached); do
	bundler exec jekyll prepublish -p "$pending_file"
	((total_failed_validators+=$?))
done

exit $total_failed_validators
```

## Development

To install, execute `bundler install`.

To run unit tests, execute `rake spec`.

## Contributing

Bug reports and pull requests are welcome on Github at
https://github.com/karepker/jekyll-prepublish. This is a personal, best-effort
project, so no [SLA][Service Level Agreement] is provided for fixes. In the
unlikely case that this actually attracts attention, I will try and review and
respond appropriately as soon as I can to anything I can help with.

[Service Level Agreement]: https://en.wikipedia.org/wiki/Service-level_agreement
