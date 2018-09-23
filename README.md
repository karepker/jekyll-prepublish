# `jekyll-prepublish`

`jekyll-prepublish` is a gem for running arbitrary validation against individual
posts and outputting errors based on their content or configuration.

## Installation

Currently `jekyll-prepublish` is available on Github. You may install it by
adding the following configuration to your applications Gemfile.

```
gem 'jekyll-prepublish', :git => 'https://github.com/karepker/jekyll-prepublish.git'
```

And then running `bundler update`.

## Usage

### Standalone

To run `jekyll-prepublish` against an arbitrary post, execute: `bundler exec
jekyll prepublish -p "/path/to/your/post` in the jekyll root directory of your
website, replacing `/path/to/your/post` with the path to your post relative to
the jekyll root directory.

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

Bug reports and pull requests are welcome on GitHub at
https://github.com/karepker/jekyll-prepublish. This is a personal, best-effort
project, so no [SLA][Service Level Agreement] is provided for fixes. In the
unlikely case that this actually attracts attention, I will try and review and
respond appropriately as soon as I can to anything I can help with.

[Service Level Agreement]: https://en.wikipedia.org/wiki/Service-level_agreement
