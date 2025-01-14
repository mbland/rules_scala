#!/usr/bin/env bash

set -eou pipefail

bazel run \
    --platforms=@platforms//host \
    --host_platform=@platforms//host \
    --extra_execution_platforms=@platforms//host \
    --action_env=BAZEL_DO_NOT_DETECT_CPP_TOOLCHAIN= \
    --host_action_env=BAZEL_DO_NOT_DETECT_CPP_TOOLCHAIN= \
    --remote_executor= \
    //tools:lint_check
