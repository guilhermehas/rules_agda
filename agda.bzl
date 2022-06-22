load("agda_toolchain.bzl", "AGDA_TOOLCHAIN")

def _agda_html_impl(ctx):
    toolchain = ctx.toolchains[AGDA_TOOLCHAIN]
    compiler = toolchain.compiler.files_to_run.executable
    inputs = ctx.files.inputs
    input = inputs[0]
    file_name = ctx.file.main_file.path
    out = ctx.actions.declare_directory("html")
    
    ctx.actions.run(
        mnemonic = "agda",
        inputs = inputs + [ctx.file.main_file],
        arguments = [ "--no-libraries", "-i", input.dirname, "--html", "--html-dir", out.path, file_name],
        executable = compiler,
        outputs = [ out ],
    )

    return [
        DefaultInfo(files = depset([out]), runfiles=ctx.runfiles(files=[out]))
    ]

agda_html = rule(
    _agda_html_impl,
    attrs = {
        "inputs": attr.label_list(allow_files = [".agda", ".agda-lib"]),
        "main_file": attr.label(
            allow_single_file = [".agda"],
        ),
    },
    toolchains = [AGDA_TOOLCHAIN],
)
