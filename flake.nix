{
  description = "Minimal public bootstrap flake for NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-wsl,
      ...
    }@inputs:
    {
      nixosConfigurations = {
        wsl = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            nixos-wsl.nixosModules.default
            ./modules/base.nix
            ./modules/wsl.nix
            ./hosts/wsl/configuration.nix
          ];
        };
      };
    };
}
