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
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = {
    nixpkgs,
    home-manager,
    hyprland,
    stylix,
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
        {
          wayland.windowManager.hyprland = {
            enable = true;
            package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
          };
        }
        stylix.homeManagerModules.stylix
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
