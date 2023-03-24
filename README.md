# Decidim Gava

This is the opensource code repository for "decidim-gava", based on [Decidim](https://github.com/decidim/decidim)

## Development environment setup

- Ruby version: 2.7.4
- Node version: 16.13.0

Copy config files:

```bash
cp .env.example .env
ln -s .env .rbenv-vars
```

Review `config/database.yml` and adjust the credentials at your preference.

Install dependencies:

```bash
bundle
```

**Setup database:**

```bash
createuser decidim-gava
```

Give this user admin privileges:

```bash
psql
# And then run:
ALTER USER decidim-gava WITH SUPERUSER;
```

Create and migrate the DB:

```bash
bin/rails db:create db:migrate
bin/rails db:seed # WARNING: this is not idempotent. If a unqueness validations fails, drop and re-create
```

## Customizations

### Census integration

- `app/views/census_authorization/_form.html.erb`: defines the form
- `app/services/census_authorization_handler.rb`: defines a service to deal with the authorization
- `lib/census_rest_client`: defines a client to interact with the census API

### Custom reports

At `lib/reports/` you can find some custom reports the client requested. They shoudl be executed with `rails runner`

### Custom anominization

At `lib/tasks/anonymize.rake` you can find a task to anonymize the database.


## Licence

Code published under AFFERO GPL v3 (see [LICENSE-AGPLv3.txt](LICENSE-AGPLv3.txt))

## Code of conduct

See [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md)
