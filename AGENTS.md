# Repository Guidelines

## Project Structure & Module Organization

This is a small Ruby gem that wraps selected Yunxuetang APIs. The public entry point is `lib/yxt-api.rb`, which loads feature modules from `lib/yxt-api/`. Each API area has a focused file, for example `lib/yxt-api/user.rb`, `position.rb`, and `department.rb`. Version metadata lives in `lib/yxt-api/version.rb`. Gem packaging is configured in `yxt-api.gemspec`, with Bundler tasks in `Rakefile`.

There is currently no committed `spec/` directory. Add tests under `spec/` when changing behavior, mirroring the relevant module name, such as `spec/yxt_api/user_spec.rb`.

## Build, Test, and Development Commands

- `bundle install`: install runtime and development dependencies from `Gemfile` and the gemspec.
- `bundle exec rake`: run the default task, currently the RSpec suite.
- `bundle exec rake spec`: run specs explicitly.
- `bundle exec gem build yxt-api.gemspec`: build the gem package locally.

Use `bundle exec` for repository commands so the locked dependency versions are used.

## Coding Style & Naming Conventions

Use Ruby 2.7-compatible syntax. Keep `# frozen_string_literal: true` at the top of Ruby source files. Follow the existing style: two-space indentation, single quotes for simple strings, and small module methods on `Yxt`.

Name API wrapper methods after the upstream endpoint conventions already present, for example `positions_sync`, `positioncatalogs_sync`, and `users_recoversync`. Keep endpoint strings in the method body and delegate HTTP behavior through `Yxt.request`.

## Testing Guidelines

RSpec is the configured test framework. Place new specs in `spec/` and name files with the `_spec.rb` suffix. Prefer focused unit tests that stub HTTPX or `Yxt.request` rather than calling the real Yunxuetang service. Cover token caching, request retry behavior, and endpoint wrapper payloads when those areas change.

Run `bundle exec rake` before submitting changes.

## Commit & Pull Request Guidelines

Recent commits use short, imperative subjects such as `Fix`, `Allow high version`, and `New positions_sync API`. Keep commit messages concise and action-oriented; add a longer body only when the reason is not obvious.

Pull requests should include a brief summary, testing performed, and any API documentation links used. For behavior changes, note compatibility concerns for existing consumers of the gem.

## Security & Configuration Tips

Do not commit private keys, access tokens, or local token cache files. The gemspec references `certs/Eric-Guo.pem` for signing; keep private signing keys outside the repository. Avoid committing editor artifacts such as `.DS_Store` or workspace files.
