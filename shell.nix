{ pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/5e2018f7b383aeca6824a30c0cd1978c9532a46a.tar.gz") {} }:

with pkgs;

let
  core = [
    beam.packages.erlang.elixir
    rebar
    rebar3
    nodejs
  ];
  deployTools = [heroku kubectl];
  utilities = [glibcLocales libnotify inotify-tools];
  
  hooks = ''
    # this allows mix to work on the local directory
    mkdir -p .nix-mix .nix-hex
    export MIX_HOME=$PWD/.nix-mix
    export HEX_HOME=$PWD/.nix-hex
    export PATH=$MIX_HOME/bin:$HEX_HOME/bin:$PATH
    
    mix local.hex --force --if-missing
    mix local.rebar rebar ${rebar}/bin/rebar --force
    mix local.rebar rebar3 ${rebar3}/bin/rebar3 --force
    
    export LANG=en_US.UTF-8
    export ERL_AFLAGS="-kernel shell_history enabled"
  '';
in

mkShell {
  buildInputs = core ++ deployTools ++ utilities;
  shellHooks = hooks;
}
