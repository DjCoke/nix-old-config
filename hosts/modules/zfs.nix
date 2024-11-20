{ pkgs, ... }:
{
  networking.hostId = "266c73a2";
  environment.systemPackages = [ pkgs.zfs-prune-snapshots ];
  boot = {
    kernelParams = [
      "nohibernate"
      "zfs.zfs_arc_max=17179869184"
    ];
    supportedFilesystems = [ "vfat" "zfs" ];
    zfs = {
      devNodes = "/dev/disk/by-id/";
      forceImportAll = true;
      requestEncryptionCredentials = true;
    };
  };
  services.zfs = {
    autoScrub.enable = true;
    trim.enable = true;
  };


}
