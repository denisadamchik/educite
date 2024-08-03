# Educite
API-only app for online courses.

## Getting started

1. Clone the repository and navigate to the directory:

   ```shell
   $ git clone git@github.com:denisadamchik/educite.git
   $ cd educite
   ```

2. Install the right Ruby version:

   ```shell
   $ grep "ruby \"" Gemfile
   $ rvm install <version>
   $ rvm use <version>
   ```

3. Install PostgreSQL using [this instruction](https://www.postgresqltutorial.com/postgresql-getting-started/install-postgresql-linux/).

4. Create a role and databases:

   ```shell
   $ sudo -u postgres psql < db/postgres/init.sql
   ```

5. Install dependencies:

   ```shell
   $ bundle install
   ```

6. Prepare the database:

   ```shell
   $ bin/rails db:migrate
   $ bin/rails db:seed
   ```

7. Run tests to make sure everything is ok:

    ```shell
    $ bundle exec rspec
    ```

8. Run rswag:

    ```shell
    $ RAILS_ENV=test rails rswag
    ```

9. Run Rails:

    ```shell
    $ rails server
    ```

10. Open <http://localhost:3000/api-docs/index.html>
