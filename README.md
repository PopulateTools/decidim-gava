![decidim-barcelona logo]
(https://raw.githubusercontent.com/AjuntamentdeBarcelona/decidim.barcelona/master/app/assets/images/decidim-logo.png)

# decidim-gava

---

Citizen Participation and Open Government Application

[![Build Status](https://img.shields.io/travis/AjuntamentdeBarcelona/decidim-barcelona/master.svg)](https://travis-ci.org/AjuntamentdeBarcelona/decidim-barcelona)
[![codecov](https://codecov.io/gh/AjuntamentdeBarcelona/decidim-barcelona/branch/master/graph/badge.svg)](https://codecov.io/gh/AjuntamentdeBarcelona/decidim-barcelona)
[![Code Climate](https://codeclimate.com/github/AjuntamentdeBarcelona/decidim-barcelona/badges/gpa.svg)](https://codeclimate.com/github/AjuntamentdeBarcelona/decidim-barcelona)
[![Dependency Status](https://gemnasium.com/AjuntamentdeBarcelona/decidim-barcelona.svg)](https://gemnasium.com/AjuntamentdeBarcelona/decidim-barcelona)

This is the opensource code repository for "decidim-barcelona", based on [Decidim](https://github.com/AjuntamentdeBarcelona/decidim).

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

```
bin/rails db:create db:migrate
bin/rails db:seed
```

## Licence

Code published under AFFERO GPL v3 (see [LICENSE-AGPLv3.txt](LICENSE-AGPLv3.txt))

## Code of conduct

See [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md)
