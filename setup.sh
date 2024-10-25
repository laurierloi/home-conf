# Reference used: https://www.chrisportela.com/posts/home-manager-flake/
nix run . -- build --impure --flake .
nix run . -- switch --impure --flake .
