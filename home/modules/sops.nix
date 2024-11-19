# sops configuration for Home Manager

{ inputs, ... }:
{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];



}
