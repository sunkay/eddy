# Eddy

**TODO: To boldly develop whatever comes to mind and having no targets**

An elixir and phoenix application:
  * fork tag v0.1 to have a starter app that handles identity based Authentication & integrates with oAuth providers: Google, Facebook & Github
  * adding other oAuth providers is trivial, due to the excellent ueberauth package
  

To start your Phoenix app:

  * Install dependencies with mix deps.get
  * Create and migrate your database with mix ecto.create && mix ecto.migrate
  * Install Node.js dependencies with npm install
  * Start Phoenix endpoint with mix phoenix.server
  * Now you can visit localhost:4000 from your browser.

## oAuth client id's and secrets should be added to your env. in .bashrc
  * export FACEBOOK_CLIENT_ID="123"
  * export FACEBOOK_CLIENT_SECRET="123saf"
  * export GITHUB_CLIENT_ID="adsf"
  * export GITHUB_CLIENT_SECRET="asf"
  * export GOOGLE_CLIENT_ID="saf"
  * export GOOGLE_CLIENT_SECRET="adsf"
