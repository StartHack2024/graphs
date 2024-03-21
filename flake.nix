{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ flake-parts, ... }: flake-parts.lib.mkFlake { inherit inputs; } {
    systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];

    perSystem = { pkgs, ... }: {
      devShells.default =
        let
          python-with-packages = pkgs.python3.withPackages (ps: with ps; [
            jupyter
            notebook

            gdal
            numpy
            seaborn
            scipy
          ]);
        in
        pkgs.mkShell {
          packages = [
            python-with-packages
            pkgs.nodePackages.pyright
            pkgs.ruff-lsp
          ];

          shellHook = ''
            PYTHONPATH=${python-with-packages}/${python-with-packages.sitePackages}
          '';
        };
    };
  };
}
