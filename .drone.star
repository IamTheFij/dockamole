# Build pipelines
def main(ctx):
    pipelines = []

    # Add docker push pipelines
    pipelines += push_to_docker(ctx, "client")
    pipelines += push_to_docker(ctx, "server")

    return pipelines


# Builds a pipeline to push to docker
def push_to_docker(ctx, context):
    return [{
        "kind": "pipeline",
        "name": "push to docker ({})".format(context),
        # Add tests dependency
        "depends_on": [],
        "trigger": {
            "event": ["push", "tag"],
            "ref": [
                "refs/heads/master",
                "refs/tags/v*",
            ],
        },
        "steps": [
            push_docker_step(context, "linux-amd64", "x86_64", "library"),
            push_docker_step(context, "linux-arm", "arm", "arm32v6"),
            push_docker_step(context, "linux-arm64", "aarch64", "arm64v8"),
            {
                "name": "publish manifest",
                "image": "plugins/manifest",
                "settings": {
                    "spec": "{}/manifest.tmpl".format(context),
                    "auto_tag": True,
                    "ignore_missing": True,
                    "username": {
                        "from_secret": "docker_username",
                    },
                    "password": {
                        "from_secret": "docker_password",
                    },
                }
            },
            notify_step(),
        ],
    }]


# Build and push docker image
def push_docker_step(context, tag_suffix, arch="amd64", repo="library"):
    return {
        "name": "build",
        "image": "plugins/docker",
        "settings": {
            "repo": "iamthefij/dockamole-{}".format(context),
            "context": context,
            "auto_tag": True,
            "auto_tag_suffix": tag_suffix,
            "username": {
                "from_secret": "docker_username",
            },
            "password": {
                "from_secret": "docker_password",
            },
            "build_args": [
                "ARCH={}".format(arch),
                "REPO={}".format(repo),
            ],
        },
    }


# Builds a notify step that will notify when the previous step changes
def notify_step():
    return {
        "name": "notify",
        "image": "drillster/drone-email",
        "settings": {
            "host": {
                "from_secret": "SMTP_HOST",
            },
            "username": {
                "from_secret": "SMTP_USER",
            },
            "password": {
                "from_secret": "SMTP_PASS",
            },
            "from": "drone@iamthefij.com",
        },
        "when": {
            "status": [
                "changed",
                "failure",
            ],
        },
    }


# vim: ft=python
