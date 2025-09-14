function va
    if test -f .venv/bin/activate.fish
        source .venv/bin/activate.fish
    else if test -f *-venv/bin/activate.fish
        source *-venv/bin/activate.fish
    else
        echo "No virtual environment found." >&2
        return 1
    end
end