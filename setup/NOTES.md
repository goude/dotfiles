# Installation Notes

FIXME: see if this can be made more elegant. what actually is needed? a certain number of packages to be installed either apt install or brew install - but ansible is overkill for this prob. also the setup scripts can be made more elegant and prob idempotent as well

FIXME: this setup/ subdir should be simple but support setting up a working environment around the dotfiles repo meaning mainly a lazyvim installation,uv python 3.12+(latest stable),node at some stable version(22+),and it should work for my main working environments like rpi500, macos brew, ubuntu lts server, (and also secondarily wsl2)

FIXME: restructure this into something elegant and easy to use

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
