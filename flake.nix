{
  description = "NixOS and nix-darwin configs for my machines";
  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NixOS profiles to optimize settings for different hardware
    # Instructions to be found in: https://github.com/NixOS/nixos-hardware/tree/master
    hardware.url = "github:nixos/nixos-hardware";

    # Global catppuccin theme
    catppuccin.url = "github:catppuccin/nix";

    # Removed spicetefy (because I do not use it)

    # Nix Darwin (for MacOS machines)
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Homebrew
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs =
    { self
    , catppuccin
    , darwin
    , home-manager
    , nix-homebrew
    , nixpkgs
    , ...
    } @ inputs:
    let
      inherit (self) outputs;

      # Define user configurations
      users = {
        erwin = {
          avatar = ./files/avatar/face; #TODO: Find a face or avatar
          email = "erwin.vd.glind@me.com";
          fullName = "Erwin van de Glind";
          name = "erwin";
        };
      };

      # Function for NixOS system configuration
      mkNixosConfiguration = hostname: username:
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs hostname;
            userConfig = users.${username};
          };
          modules = [ ./hosts/${hostname}/configuration.nix ];
        };

      # Function for nix-darwin system configuration
      mkDarwinConfiguration = hostname: username:
        darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = {
            inherit inputs outputs hostname;
            userConfig = users.${username};
          };
          modules = [
            ./hosts/${hostname}/configuration.nix
            home-manager.darwinModules.home-manager
            nix-homebrew.darwinModules.nix-homebrew
          ];
        };

      # Function for Home Manager configuration
      mkHomeConfiguration = system: username: hostname:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { inherit system; };
          extraSpecialArgs = {
            inherit inputs outputs;
            userConfig = users.${username};
          };
          modules = [
            ./home/${username}/${hostname}.nix
            catppuccin.homeManagerModules.catppuccin
          ];
        };
    in
    {
      nixosConfigurations = {
        k3s-01 = mkNixosConfiguration "k3s-01" "erwin"; # First k3s-01 node
        k3s-02 = mkNixosConfiguration "k3s-02" "erwin"; # Second k3s-02 node
        k3s-03 = mkNixosConfiguration "k3s-03" "erwin"; # Second k3s-03 node
      };

      darwinConfigurations = {
        "nabokikh-mac" = mkDarwinConfiguration "nabokikh-mac" "nabokikh";
      };

      homeConfigurations = {
        "erwin@k3s-01" = mkHomeConfiguration "x86_64-linux" "erwin" "k3s-01";
        "erwin@k3s-02" = mkHomeConfiguration "x86_64-linux" "erwin" "k3s-02";
        "erwin@k3s-03" = mkHomeConfiguration "x86_64-linux" "erwin" "k3s-03";
        "nabokikh@nabokikh-mac" = mkHomeConfiguration "aarch64-darwin" "nabokikh" "nabokikh-mac";
        "nabokikh@nabokikh-z13" = mkHomeConfiguration "x86_64-linux" "nabokikh" "nabokikh-z13";
      };

      overlays = import ./overlays { inherit inputs; };
    };
}
