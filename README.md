
# Decidim Gava
This is the opensource code repository for "decidim-gava", based on [Decidim](https://github.com/decidim/decidim)

## Development environment setup

Copy config files:

```bash
cp config/database.yml.example config/database.yml
cp .env.example .env
ln -s .env .rbenv-vars
```

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

## Licence

Code published under AFFERO GPL v3 (see [LICENSE-AGPLv3.txt](LICENSE-AGPLv3.txt))

## Code of conduct

See [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md)
