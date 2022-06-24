load("agda_toolchain.bzl", "AGDA_TOOLCHAIN")

def pathBefore(s):
    barc = s.count("/")
    path = ""
    for _ in range(barc):
        path += "../"
    return path

def addPathBefore(s):
    return lambda x: pathBefore(s.path) + x.path

def _agda_html_impl(ctx):
    toolchain = ctx.toolchains[AGDA_TOOLCHAIN]
    compiler = toolchain.compiler.files_to_run.executable
    inputs = ctx.files.inputs
    main_file = ctx.file.main_file
    agda_lib = ctx.file.agda_lib
    pBef = addPathBefore(main_file)
    file_name = main_file.path
    out = ctx.actions.declare_directory("html")
    
    ctx.actions.run_shell(
        inputs = inputs + [main_file] + [compiler] + [agda_lib],
        arguments = [ "--no-libraries", "--html", "--html-dir", pBef(out) , main_file.basename],
        outputs = [out],
        command = "cd {dir} && {compiler} $@".format(
            dir = main_file.dirname,
            compiler = pBef(compiler),
        )
    )

    # ctx.actions.run(
    #     mnemonic = "agda",
    #     inputs = inputs + [main_file],
    #     arguments = [ "--no-libraries", "-i", main_file.dirname, "--html", "--html-dir", out.path, file_name],
    #     executable = compiler,
    #     outputs = [out],
    # )

    return [
        DefaultInfo(files = depset([out]), runfiles=ctx.runfiles(files=[out]))
    ]

agda_html = rule(
    _agda_html_impl,
    attrs = {
        "inputs": attr.label_list(allow_files = [".agda"]),
        "main_file": attr.label(
            allow_single_file = [".agda"],
            mandatory = True,
        ),
        "agda_lib": attr.label(
            allow_single_file = [".agda-lib"],
        ),
    },
    toolchains = [AGDA_TOOLCHAIN],
)
