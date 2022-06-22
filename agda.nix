let
    pkgs = import <nixpkgs> { config = {}; overrides = []; };
    agda = pkgs.agda;
in
pkgs.buildEnv {
    name = "agda-toolchain";
    extraOutputsToInstall = ["out" "bin" "lib"];
    paths = [ agda ];
    postBuild = ''

    mkdir -p $out

    cat >$out/BUILD.bazel <<'EOF_BUILD'
    load('agda.bzl', 'agda')
    load("agda_toolchain.bzl", "agda_toolchain_info", "AGDA_TOOLCHAIN", "AGDA_TOOLCHAIN_TYPE")

    filegroup(
        name = "agda-filegroup",
        srcs = ["bin/agda"],
        visibility = ["//visibility:public"],
    )

    agda_toolchain_info(
        name = "agda-nixos-toolchain-info2",
        compiler = ":agda-filegroup"
    )

    toolchain(
        name = "agda-nixos-toolchain2",
        exec_compatible_with = [
            "@bazel_tools//platforms:x86_64",
        ],
        target_compatible_with = [
            "@bazel_tools//platforms:x86_64",
        ],
        toolchain = ":agda-nixos-toolchain-info2",
        toolchain_type = AGDA_TOOLCHAIN,
    )

    agda(
        name = "agda-nix",
        inputs = ["a.agda"],
        visibility = ["//visibility:public"],
    )
    EOF_BUILD
  '';
}
