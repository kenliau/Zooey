Zooey
=====

A front end for Video transcoding SAAS.

A few things that need to add for it to work. 

### 1. config/database.yml

In database.yml, set up the environment variables as you need it. 
For example in .bash_profile OR .bashrc put this:

  `export ZOOEY_DEV_DATABASE=example_database`

### 2. secret_token.rb
In config/initializers/secret_token.rb, please do the same and set up
environment variables or else it will use the default one. Run
  `rake secret`
to generate 32 characters. 

`export ZOOEY_SECRET_TOKEN=asdfadsfasdf`

### 3. .ruby-version .ruby-gemsets 
Change the version of ruby and gemset you wish to use.
