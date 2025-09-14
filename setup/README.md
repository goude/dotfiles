# Installation Notes

## starship

For now the fish init for starship is using a workaround. This will probably not be needed once
a newer version of fish is used.

<https://github.com/starship/starship/issues/6336>

```bash
starship init fish --print-full-init | sed 's/"$(commandline)"/(commandline | string collect)/' | source
```

## Rstudio Server

- .Renviron: set https?\_proxy and possibly TZ="Europe/Stockholm"
- <https://posit.co/download/rstudio-server/>
- sudo apt-get install -y libxml2-dev libcurl4-openssl-dev libssl-dev
