AGDA_TOOLCHAIN_TYPE = "agda-toolchain-type"
AGDA_TOOLCHAIN = "//:agda-toolchain-type"

def _agda_toolchain_info(ctx):
    return [ platform_common.ToolchainInfo(
        compiler = ctx.attr.compiler,
        ),
    ]

agda_toolchain_info = rule(
    _agda_toolchain_info,
    attrs = {
        "compiler": attr.label(
            allow_single_file = True,
            cfg = "exec",
            # executable = True,
        ),
    },
)

