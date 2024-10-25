{
  description = "Home Manager Flake for Laurier Loiselle";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # TODO: we could add flake-utils to support more systems
  outputs = {nixpkgs, home-manager, ...}: {
      packages.x86_64-linux.default = home-manager.defaultPackage.x86_64-linux;

      homeConfigurations = {
          lal = home-manager.lib.homeManagerConfiguration {
              pkgs = import nixpkgs { system = "x86_64-linux"; };
              modules = [ ./home-manager/home.nix ];
          };
      };
  };
}
