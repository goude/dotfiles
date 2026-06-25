function ls --description 'eza/exa wrapper that dims rarely-used dirs in $HOME'
    # --- config -------------------------------------------------------------
    # Directories dimmed when listing $HOME. Override per-machine with e.g.
    #   set -U dim_dirs Music Public snap
    # Cross-platform on purpose: names that don't exist on a box simply never
    # match. Covers Linux (Templates/Videos) and macOS (Movies/Applications).
    if not set -q dim_dirs
        set -g dim_dirs Desktop Public Templates Videos Movies Music Pictures Downloads Applications
    end
    # SGR used for the dim. Default is faint (theme-adaptive: greys on a dark
    # theme, fades toward white on a light one). Override with e.g.
    #   set -U dim_color '38;5;240'   # a fixed mid-grey
    set -q dim_color; or set -l dim_color 2

    # --- pick a lister ------------------------------------------------------
    set -l bin
    if command -q eza
        set bin eza
    else if command -q exa
        set bin exa
    else
        # No modern lister: just hand off to plain ls.
        command ls $argv
        return
    end

    # --- fast path: not the special case -> transparent passthrough ---------
    # Dimming needs eza (forced icons/grid/width syntax), a real terminal, the
    # home dir, and a non-empty list.
    if test "$bin" != eza; or not isatty stdout; or test "$PWD" != "$HOME"; or not set -q dim_dirs[1]
        $bin --classify --icons=auto --color=auto $argv
        return
    end

    # --- dim path -----------------------------------------------------------
    # Don't force a grid when the user asked for a line-based layout.
    set -l grid --grid
    if string match -qr -- '^-[A-Za-z]*l|^--long$|^-1$|^--oneline$|^-[A-Za-z]*T|^--tree$' $argv
        set grid
    end
    set -l width
    test -n "$COLUMNS"; and set width --width=$COLUMNS

    # Build a portable sed program with a literal ESC byte (works on GNU *and*
    # BSD sed; \x1b does not). eza wraps "<icon> <name>" in one colour span, so
    # we repaint the whole span. [^ESC] keeps the match inside one grid cell.
    # NB: keep every literal '[' inside single quotes so fish never reads a
    # '$var[' as an array index. Bare variables are concatenated between the
    # quoted regex/replacement fragments.
    set -l esc (printf '\033')
    set -l names (string join '|' $dim_dirs)
    set -l prog 's/'$esc'\[[0-9;]+m(([^'$esc']* )?('$names'))'$esc'\[0m/'$esc'['$dim_color'm\1'$esc'[0m/g'

    $bin --classify --icons=always --color=always $grid $width $argv | sed -E $prog
end
