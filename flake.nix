{
  description = "zwezda2";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
      {
        packages = rec {
          taler-bank = pkgs.dockerTools.buildLayeredImage {
            name = "taler-bank";
            tag = "latest";
            contents = [ pkgs.libeufin ];
            config = {
              Cmd = [ "${pkgs.libeufin}/bin/libeufin-bank" ];
            };
          };

          taler-exchange = pkgs.dockerTools.buildLayeredImage {
            name = "taler-exchange";
            tag = "latest";
            contents = [
              pkgs.libeufin
              pkgs.sudo
              pkgs.nginx
              pkgs.coreutils
              taler-exchange-entrypoint
            ];
            config = {
              user = "www-data";
              Cmd = [
                "${pkgs.bash}/bin/bash"
                "${taler-exchange-entrypoint}/script.sh"
                "${pkgs.taler-exchange}"
                "${pkgs.nginx}"
                "${pkgs.coreutils}"
              ];
            };
          };

          taler-exchange-entrypoint = pkgs.stdenv.mkDerivation {
            name = "taler-exchange";
            src = ./.;
            buildPhase = ''
              mkdir -p $out
              cp taler-exchange-entrypoint.sh $out/script.sh
              chmod +x $out/script.sh
            '';
          };
        };
      }
    );
}
