load("agda_toolchain.bzl", "AGDA_TOOLCHAIN")

def _agda_impl(ctx):
    toolchain = ctx.toolchains[AGDA_TOOLCHAIN]
    compiler = toolchain.compiler.files.to_list()[0]
    inputs = ctx.files.inputs
    input = inputs[0]
    file_name = input.path
    html_name = input.basename[:-len(input.extension)] + "html"
    out = ctx.actions.declare_directory("html")
    ctx.actions.run(
        mnemonic = "agda",
        inputs = inputs,
        arguments = [ "--no-libraries", "-i", input.dirname, "--html", "--html-dir", out.path , file_name ],
        executable = compiler,
        outputs = [ out ],
    )

    return [
        DefaultInfo(files = depset([out]), runfiles=ctx.runfiles(files=[out]))
    ]

agda = rule(
    _agda_impl,
    attrs = {
        "inputs": attr.label_list(allow_files = [".agda"]),
    },
    toolchains = [AGDA_TOOLCHAIN],
)
