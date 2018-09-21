# Umawianko
Umawianko app.

## Development requirements
- ruby 2.5.0
- yarn

## Importing icomoon icons
Open **IcoMoon App** and import `icomoon.json` file. Add your icons and download as font. Then run import script:
```bash
bundle exec rails runner bin/icomoon_import ./path/to/dir
```
`path/to/dir` should point at `um-icons` directory location. Default is "~/Desktop".
