![Kickoff Tailwind](https://f001.backblazeb2.com/file/webcrunch/kt.jpg)

A free and simple starting point for Ruby on Rails 7 applications.. This particular template utilizes [Tailwind CSS](https://tailwindcss.com/), a utility-first CSS framework for rapid UI development.

### Included gems

- [devise](https://github.com/plataformatec/devise)
- [friendly_id](https://github.com/norman/friendly_id)
- [sidekiq](https://github.com/mperham/sidekiq)
- [name_of_person](https://github.com/basecamp/name_of_person)
- [stripe](https://github.com/stripe/stripe-ruby)
- [css-bundling](https://github.com/rails/cssbundling-rails) - now part of Rails 7

### Tailwind CSS by default

This template comes with Tailwind CSS preconfigured for use. To make use of tools like `@apply` and `@layer` a more sophisticated setup is required likely using PostCSS and JavaScript bundling.

## How it works

When creating a new rails app simply pass the template filename and ruby extension through. Andy opted for esbuild instead of the default importmap configuration for JavaScript. 

```bash
$ rails new sample_app -j esbuild -m template.rb
```

### Once installed what do I get?

- [Tailwind CSS](https://tailwind.com) by default. You may [opt for Bootstrap, Bulma, Sass, and PostCSS](https://github.com/rails/cssbundling-rails#installation) but this will require manual changes to the existing markup in the generated template view files.
- [Devise](https://github.com/plataformatec/devise) with a new `name` field already migrated in. The name field maps to the `first_name` and `last_name` fields in the database thanks to the [`name_of_person`](https://github.com/basecamp/name_of_person) gem.
- Enhanced views and devise views using Tailwind CSS.
- The [Stripe](https://rubygems.org/gems/stripe/) gem installed with the Stripe API to make accepting payments on the web. Be sure to add your own unique API keys.
- Support for Friendly IDs thanks to the handy [friendly_id](https://github.com/norman/friendly_id) gem. Note that you'll still need to do some work inside your models for this to work. This template installs the gem and runs the associated generator.
- Optional Foreman support. Run `.bin/dev` to kick off rails and Tailwind processes. Foreman needs to be installed as a global gem on your system for this to work. i.e. `gem install foreman`
- Custom view helper defaults for basic button and form elements.
- Scaffolding templates made with Tailwind CSS

### What do I not get?
- This is not intended for production applications in it's current state. (This is entended to save you two days of boilerplate config work if you are already familiar with Devise and Tailwind.) 

### Changes on this fork
- [Devise](https://github.com/plataformatec/devise) version bumped to 4.9.8. 
- We have turned on fields in Devise for :confirmable (generated confirmation links can be accessed in development with the mailcatcher gem or by looking at the development server log)
- The navbar has been updated to work with modern rails turbo 
- The beginnings of a separate User CRUD have been added (This would, like many other aspects of this fork, need to be locked down before ever going near a production environment).

### Possible future extension
- [Devise-Invitable](https://github.com/plataformatec/devise)
- [Devise-Two-Factor](https://github.com/devise-two-factor/devise-two-factor)
- [omniauth-google-oauth2](https://github.com/zquestz/omniauth-google-oauth2)


### Boot it up

`$ ./bin/dev`


### Credits

This adaptation by Greg Van de Mosselaer

Made by @justalever (yours truly). Find me on [Twitter](https://twitter.com/justalever), [web-crunch.com](https://web-crunch.com), [GitHub](https://github.com/justalever).
