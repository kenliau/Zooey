Zooey-Deschanel
===============

A front end for Video transcoding SAAS.

A few things that need to add for it to work. 

1. database.yml

  `cp config/database.yml.example config/database.yml`

2. Edit database.yml to match your database credentials

3. secret_token.rb

  `cp config/initializers/secret_token.rb.example config/initializers/secret_token.rb`

4. Run this command to get a secret key for rails

  `rake secret`

5. Copy the 32 characters generate and replace it with the one in secret_token.rb

6. .rvmrc
  
  `cp .rvmrc.example .rvmrc`

7. change the version of gemset you wish to use
