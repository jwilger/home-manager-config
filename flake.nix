{
  description = "Home Manager configuration of jwilger";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zjstatus = {
      url = "github:dj95/zjstatus";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvim = {
      url = "github:jwilger/neovim_nix_config";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    stylix,
    nvim,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    homeConfigurations."jwilger" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      # Specify your home configuration modules here, for example,
      # the path to your home.nix.
      modules = [
        stylix.homeManagerModules.stylix
        nvim.homeModule
        ./home.nix
      ];

      # Optionally use extraSpecialArgs
      # to pass through arguments to home.nix
      extraSpecialArgs = {
        inherit inputs;
      };
    };
  };
}
