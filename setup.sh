# Reference used: https://www.chrisportela.com/posts/home-manager-flake/
NIXPKGS_ALLOW_UNFREE=1 nix run . -- build --impure --flake .
NIXPKGS_ALLOW_UNFREE=1 nix run . -- switch --impure --flake .
